//
//  UIFont+BoxGuide.m
//  BoxGuide
//
//  Created by Martin Heras on 11/3/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "UIFont+BoxGuide.h"

@implementation UIFont (BoxGuide)

+ (UIFont *)bg_defaultFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Futura-Medium" size:size];
}

+ (UIFont *)bg_defaultBoldFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Futura-CondensedExtraBold" size:size];
}

+ (UIFont *)bg_fontAwesomeFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"FontAwesome" size:size];
}

@end
