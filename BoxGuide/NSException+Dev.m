//
//  NSException+BoxGuide.m
//  BoxGuide
//
//  Created by Martin Heras on 10/9/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "NSException+Dev.h"

@implementation NSException (Dev)

+ (NSException *)bg_singletonExceptionWithClass:(Class)clazz
{
    return [NSException exceptionWithName:@"BGSingletonInstantiationException" reason:[NSString stringWithFormat:@"Cannot instantiate an object of class '%@'. It's a singleton and there should be a method called sharedInstance to get the instance.", NSStringFromClass(clazz)] userInfo:nil];
}

+ (NSException *)bg_mustOverrideExceptionWithClass:(Class)clazz selector:(SEL)selector
{
    return [NSException exceptionWithName:@"BGMustOverrideException" reason:[NSString stringWithFormat:@"The method named '%@' must be overriden in class named '%@'.", NSStringFromSelector(selector), NSStringFromClass(clazz)] userInfo:nil];
}

@end
