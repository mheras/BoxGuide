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

@interface BGServicePaginatorResponse : NSObject

@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, assign) NSInteger totalObjects;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPages;

@end

@implementation BGServicePaginatorResponse
@end

@interface BGServicePaginator ()

@property (nonatomic, copy) NSString *path;

@property (nonatomic, strong) BGServicePaginatorResponse *lastResponse;

@property (nonatomic, strong) RKResponseDescriptor *responseDescriptor;

@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) RKObjectManager *manager;

@property (nonatomic, strong) RKObjectRequestOperation *requestOperation;

@property (nonatomic, copy) NSString *cacheKey;

@end

@implementation BGServicePaginator

- (id)initWithManager:(RKObjectManager *)manager objectMapping:(RKMapping *)objectMapping path:(NSString *)path parameters:(NSDictionary *)parameters cacheKey:(NSString *)cacheKey {
    
    NSAssert(manager, @"The manager cannot be nil.");
    NSAssert(objectMapping, @"The object mapping cannot be nil.");
    NSAssert([path length] > 0, @"The path cannot be nil or empty.");
    
    self = [super init];
    if (self) {
        self.path = path;
        self.manager = manager;
        self.parameters = parameters;
        [self buildResponseDescriptorWithObjectMapping:objectMapping];
    }
    return self;
}

- (void)buildResponseDescriptorWithObjectMapping:(RKMapping *)objectMapping {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[BGServicePaginatorResponse class]];
    [mapping addAttributeMappingsFromDictionary:@{@"total_pages" : @"totalPages", @"total_results" : @"totalObjects", @"page" : @"page"}];
    
    RKRelationshipMapping *relationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"results" toKeyPath:@"objects" withMapping:objectMapping];
    [mapping addPropertyMapping:relationshipMapping];
    
    self.responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:self.path keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

- (BOOL)hasLoaded {
    @synchronized(self) {
        return self.lastResponse != nil;
    }
}

- (BOOL)hasMorePages {
    @synchronized(self) {
        return !self.hasLoaded || (self.lastResponse.page < kTMDBMaxPage && self.lastResponse.page < self.lastResponse.totalPages);
    }
}

- (NSInteger)totalObjects {
    @synchronized(self) {
        return self.lastResponse != nil ? self.lastResponse.totalObjects : -1;
    }
}

- (BOOL)isLoading {
    @synchronized(self) {
        return self.requestOperation != nil;
    }
}

- (void)loadNextPageWithSuccessBlock:(void (^)(NSInteger page, NSArray *pageResults))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    
    @synchronized(self) {
        
        NSAssert(![self isLoading], @"Cannot load next page while currently loading one.");
        
        NSMutableDictionary *parameters = [self.parameters mutableCopy];
        if (!parameters) {
            parameters = [[NSMutableDictionary alloc] init];
        }
        parameters[@"page"] = @(self.lastResponse.page + 1);
        
        NSMutableURLRequest *request = [self.manager requestWithObject:nil method:RKRequestMethodGET path:self.path parameters:parameters];
        
        __weak typeof(self) weakSelf = self;
        
        self.requestOperation = [self.manager objectRequestOperationWithRequest:request currentResponseDescriptors:@[self.responseDescriptor] success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            
            weakSelf.requestOperation = nil;
            weakSelf.lastResponse = mappingResult.firstObject;
            
            if (successBlock) {
                successBlock(weakSelf.lastResponse.page, weakSelf.lastResponse.objects);
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

- (void)reset {
    @synchronized(self) {
        [self cancel];
        self.lastResponse = nil;
    }
}

- (void)clearCache {
    // TODO: Implement!
}

@end
