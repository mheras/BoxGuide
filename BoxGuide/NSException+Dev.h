//
//  NSException+BoxGuide.h
//  BoxGuide
//
//  Created by Martin Heras on 10/9/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (Dev)

+ (NSException *)bg_singletonExceptionWithClass:(Class)clazz;

+ (NSException *)bg_mustOverrideExceptionWithClass:(Class)clazz selector:(SEL)selector;

@end
