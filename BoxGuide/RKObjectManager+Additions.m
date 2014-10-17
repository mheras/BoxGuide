//
//  RKObjectManager+Additions.m
//  BoxGuide
//
//  Created by Martin Heras on 10/16/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "RKObjectManager+Additions.h"

@interface RKObjectManager ()

- (RKObjectRequestOperation *)objectRequestOperationWithRequest:(NSURLRequest *)request responseDescriptors:(NSArray *)responseDescriptors success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

@end

@implementation RKObjectManager (Additions)

- (RKObjectRequestOperation *)objectRequestOperationWithRequest:(NSURLRequest *)request currentResponseDescriptors:(NSArray *)currentResponseDescriptors success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    
    NSMutableArray *responseDescriptors = [self.responseDescriptors mutableCopy];
    if (!responseDescriptors) {
        responseDescriptors = [[NSMutableArray alloc] init];
    }
    [responseDescriptors addObjectsFromArray:currentResponseDescriptors];
    
    return [self objectRequestOperationWithRequest:request responseDescriptors:responseDescriptors success:success failure:failure];
}

@end
