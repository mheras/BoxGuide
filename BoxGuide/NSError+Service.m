//
//  NSError+Service.m
//  BoxGuide
//
//  Created by Martin Heras on 10/9/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "NSError+Service.h"
#import <RestKit/RestKit.h>

@implementation NSError (Service)

- (BGServiceError *)serviceError {
    return [self.userInfo[RKObjectMapperErrorObjectsKey] firstObject];
}

- (BOOL)isCancelledError {
    return [self.domain isEqualToString:NSURLErrorDomain] && self.code == NSURLErrorCancelled;
}

- (BOOL)isConnectionError {
    return [self.domain isEqualToString:NSURLErrorDomain] && self.code != NSURLErrorCancelled;
}

@end
