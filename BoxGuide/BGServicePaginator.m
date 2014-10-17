//
//  BGServicePaginator.m
//  BoxGuide
//
//  Created by Martin Heras on 10/16/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGServicePaginator.h"
#import "RKObjectManager+Additions.h"
#import <RestKit/RestKit.h>

static const NSInteger kTMDBMaxPage = 1000;

@interface BGServicePaginatedResults : NSObject

@property (nonatomic, strong) NSArray *results;
@property (nonatomic, assign) NSInteger totalResults;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPages;

@end

@implementation BGServicePaginatedResults
@end

@interface BGServicePaginator ()

@property (nonatomic, strong) NSMutableArray *mutableAllResults;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalResults;
@property (nonatomic, assign) NSInteger loadedPages;

@property (nonatomic, strong) RKResponseDescriptor *responseDescriptor;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) RKObjectManager *manager;

@property (nonatomic, strong) RKObjectRequestOperation *requestOperation;

@end

@implementation BGServicePaginator

- (id)initWithManager:(RKObjectManager *)manager resultsMapping:(RKMapping *)resultsMapping path:(NSString *)path parameters:(NSDictionary *)parameters {
    
    NSAssert(manager, @"The manager cannot be nil.");
    NSAssert(resultsMapping, @"The results mapping cannot be nil.");
    NSAssert([path length] > 0, @"The path cannot be nil or empty.");
    
    self = [super init];
    if (self) {
        self.path = path;
        self.manager = manager;
        self.parameters = parameters;
        [self buildResponseDescriptorWithResultsMapping:resultsMapping];
    }
    return self;
}

- (void)buildResponseDescriptorWithResultsMapping:(RKMapping *)resultsMapping {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[BGServicePaginatedResults class]];
    [mapping addAttributeMappingsFromDictionary:@{@"total_pages" : @"totalPages", @"total_results" : @"totalResults", @"page" : @"page"}];
    [mapping addRelationshipMappingWithSourceKeyPath:@"results" mapping:resultsMapping];
    
    self.responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:self.path keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

- (NSArray *)allResults {
    
    @synchronized(self) {
        return self.mutableAllResults;
    }
}

- (void)reset {
    
    @synchronized(self) {
        [self cancel];
        self.mutableAllResults = nil;
        self.loadedPages = 0;
        self.totalPages = 0;
        self.totalResults = 0;
    }
}

- (BOOL)hasMorePages {
    
    @synchronized(self) {
        return !self.allResults || (self.loadedPages < kTMDBMaxPage && self.loadedPages < self.totalPages);
    }
}

- (BOOL)isLoading {
    
    @synchronized(self) {
        return self.requestOperation != nil;
    }
}

- (void)loadNextPageWithSuccessBlock:(void (^)(NSArray *pageResults))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    
    @synchronized(self) {
        
        NSAssert(![self isLoading], @"Cannot load next page while currently loading one.");
        
        NSMutableDictionary *parameters = [self.parameters mutableCopy];
        if (!parameters) {
            parameters = [[NSMutableDictionary alloc] init];
        }
        parameters[@"page"] = @(self.loadedPages + 1);
        
        NSMutableURLRequest *request = [self.manager requestWithObject:nil method:RKRequestMethodGET path:self.path parameters:parameters];
        
        __weak typeof(self) weakSelf = self;
        
        self.requestOperation = [self.manager objectRequestOperationWithRequest:request currentResponseDescriptors:@[self.responseDescriptor] success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            
            weakSelf.requestOperation = nil;
            
            BGServicePaginatedResults *paginatedResults = mappingResult.firstObject;
            
            if ([paginatedResults.results count] > 0) {
                
                weakSelf.loadedPages++;
                
                if (!weakSelf.mutableAllResults) {
                    weakSelf.mutableAllResults = [[NSMutableArray alloc] init];
                }
            }
            
            [weakSelf.mutableAllResults addObjectsFromArray:paginatedResults.results];
            weakSelf.totalPages = paginatedResults.totalPages;
            weakSelf.totalResults = paginatedResults.totalResults;
            
            if (successBlock) {
                successBlock(paginatedResults.results);
            }
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            
            weakSelf.requestOperation = nil;
            
            if (failureBlock) {
                failureBlock(error);
            }
        }];
        
        [self.manager enqueueObjectRequestOperation:self.requestOperation];
    }
}

- (void)cancel {
    
    @synchronized(self) {
        [self.requestOperation cancel];
        self.requestOperation = nil;
    }
}

@end
