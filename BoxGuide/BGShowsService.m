//
//  BGShowsService.m
//  BoxGuide
//
//  Created by Martin Heras on 09/10/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGShowsService.h"
#import "BGShow.h"
#import <RestKit/RestKit.h>

@implementation BGShowsService

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static BGShowsService *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BGShowsService alloc] initPrivate];
    });
    return sharedInstance;
}

- (id)initPrivate {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)init {
    @throw [NSException bg_singletonExceptionWithClass:[self class]];
}

- (void)setup {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[BGShow class]];
    // TODO: This mapping does not work. Fix it!
    [mapping addAttributeMappingsFromDictionary:@{@"name" : @"name", @"poster_path" : @"posterPath"}];
    
    RKResponseDescriptor *popularShowsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:@"/3/tv/popular" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self.manager addResponseDescriptorsFromArray:@[popularShowsResponseDescriptor]];
}

- (void)popularShowsWithSuccessBlock:(void (^)(NSArray *shows))successBlock failureBlock:(void (^)(NSError *error))failureBlock {
    
    NSMutableURLRequest *request = [self.manager requestWithObject:nil method:RKRequestMethodGET path:@"/3/tv/popular" parameters:@{@"api_key" : kAPIKey}];
    
    RKObjectRequestOperation *operation = [self.manager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *shows = mappingResult.array;
        successBlock(shows);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]); // TODO: Change to DDLog.
        failureBlock(error);
    }];
    
    [self.manager enqueueObjectRequestOperation:operation];
}

// TODO: Implement requests cancellation.

@end
