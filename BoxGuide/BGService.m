//
//  BGService.m
//  BoxGuide
//
//  Created by Martin Heras on 09/10/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGService.h"
#import "BGServiceError.h"
#import <RestKit/RestKit.h>
#import "BGConstants.h"

@implementation BGService

- (RKObjectManager *)manager {
    static dispatch_once_t onceToken;
    static RKObjectManager *sharedManager;
    BGToWeak(self, weakSelf);
    dispatch_once(&onceToken, ^{
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        sharedManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBaseURL]];
        [weakSelf setupManager:sharedManager];
    });
    return sharedManager;
}

- (void)setupManager:(RKObjectManager *)manager {
    
    [self setupApplicationServerErrorToManager:manager];
}

- (void)setupApplicationServerErrorToManager:(RKObjectManager *)manager
{
    RKObjectMapping *applicationErrorMapping = [RKObjectMapping mappingForClass:[BGServiceError class]];
    [applicationErrorMapping addAttributeMappingsFromDictionary:@{@"status_code" : @"statusCode", @"status_message" : @"statusMessage"}];
    
    // Response descriptor for 4xx status codes.
    RKResponseDescriptor *applicationClientErrorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:applicationErrorMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    
    // Response descriptor for 5xx status codes.
    RKResponseDescriptor *applicationServerErrorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:applicationErrorMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError)];
    
    [manager addResponseDescriptorsFromArray:@[applicationClientErrorDescriptor, applicationServerErrorDescriptor]];
}

@end
