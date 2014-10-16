//
//  BGShowsService.h
//  BoxGuide
//
//  Created by Martin Heras on 09/10/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGService.h"

@interface BGShowsService : BGService

+ (instancetype)sharedInstance;

- (void)popularShowsWithSuccessBlock:(void (^)(NSArray *shows))successBlock failureBlock:(void (^)(NSError *error))failureBlock;

@end
