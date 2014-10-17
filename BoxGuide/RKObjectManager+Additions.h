//
//  RKObjectManager+Additions.h
//  BoxGuide
//
//  Created by Martin Heras on 10/16/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "RKObjectManager.h"

@interface RKObjectManager (Additions)

- (RKObjectRequestOperation *)objectRequestOperationWithRequest:(NSURLRequest *)request currentResponseDescriptors:(NSArray *)responseDescriptors success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

@end
