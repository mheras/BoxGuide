//
//  BGService.h
//  BoxGuide
//
//  Created by Martin Heras on 09/10/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGServicePaginator.h"

extern NSString * const kAPIKey;

@class RKObjectManager;

@interface BGService : NSObject

@property (nonatomic, strong, readonly) RKObjectManager *manager;

@end
