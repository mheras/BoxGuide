//
//  BGServiceError.h
//  BoxGuide
//
//  Created by Martin Heras on 10/9/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGServiceError : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *error;

@end