//
//  NSError+Service.h
//  BoxGuide
//
//  Created by Martin Heras on 10/9/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGServiceError.h"

@interface NSError (Service)

@property (nonatomic, strong, readonly) BGServiceError *serviceError;

@property (nonatomic, assign, readonly, getter = isCancelledError) BOOL cancelledError;
@property (nonatomic, assign, readonly, getter = isConnectionError) BOOL connectionError;

@end
