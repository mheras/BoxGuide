//
//  UIColor+BoxGuide.m
//  BoxGuide
//
//  Created by Martin Heras on 10/19/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "UIColor+BoxGuide.h"

@implementation UIColor (BoxGuide)

// TEMPLATE COLORS

+ (UIColor *)bg_selectedColor {
    return [UIColor colorWithRed:0.455f green:0.749f blue:0.918f alpha:1.00f];
}

// PUBLIC COLORS

+ (UIColor *)bg_topBarBackgroundColor {
    return [UIColor colorWithRed:0.855f green:0.314f blue:0.055f alpha:1.00f];
}

+ (UIColor *)bg_logoTextColor {
    return [UIColor colorWithRed:0.965f green:0.945f blue:0.918f alpha:1.00f];
}

+ (UIColor *)bg_topBarTextColor {
    return [UIColor colorWithRed:0.965f green:0.945f blue:0.918f alpha:1.00f];
}

+ (UIColor *)bg_tabBarSelectedBackgroundColor {
    return [UIColor bg_selectedColor];
}

+ (UIColor *)bg_tabBarTextColor {
    return [UIColor colorWithRed:0.965f green:0.945f blue:0.918f alpha:1.00f];
}

+ (UIColor *)bg_tabBarSelectedTextColor {
    return [UIColor bg_selectedColor];
}

+ (UIColor *)bg_rootMenuOptionSelectedColor {
    return [UIColor bg_selectedColor];
}

+ (UIColor *)bg_rootMenuOptionDeselectedColor {
    return [UIColor colorWithWhite:0.8f alpha:1.0f];
}

+ (UIColor *)bg_contentBackgroundColor {
    return [UIColor colorWithRed:0.255f green:0.271f blue:0.286f alpha:1.00f];
}

@end
