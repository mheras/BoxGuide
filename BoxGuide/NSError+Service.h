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

@property (nonatomic, strong, readonly) BGServiceError *bg_serviceError;

@property (nonatomic, assign, readonly, getter = bg_isCancellationError) BOOL bg_cancellationError;
@property (nonatomic, assign, readonly, getter = bg_isConnectionError) BOOL bg_connectionError;

@end
