//
//  UIColor+BoxGuide.h
//  BoxGuide
//
//  Created by Martin Heras on 10/19/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BoxGuide)

+ (UIColor *)bg_topBarColor;

+ (UIColor *)bg_colorWithHexString:(NSString *)hexString;

+ (NSString *)bg_hexValuesFromUIColor:(UIColor *)color;

@end
