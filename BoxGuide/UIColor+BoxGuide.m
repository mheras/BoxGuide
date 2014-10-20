//
//  UIColor+BoxGuide.m
//  BoxGuide
//
//  Created by Martin Heras on 10/19/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "UIColor+BoxGuide.h"
#import "UIColor+Additions.h"

@implementation UIColor (BoxGuide)

+ (UIColor *)bg_topBarColor {
    return [UIColor colorWithRed:0.169f green:0.184f blue:0.196f alpha:1.00f];
}

+ (UIColor *)bg_rootMenuOptionSelectedColor {
    return [UIColor colorWithRed:0.455f green:0.749f blue:0.918f alpha:1.00f];
}

+ (UIColor *)bg_rootMenuOptionDeselectedColor {
    return [UIColor colorWithWhite:0.8f alpha:1.0f];
}

+ (UIColor *)bg_contentBackgroundColor {
    return [UIColor colorWithRed:0.255f green:0.271f blue:0.286f alpha:1.00f];
}

@end
