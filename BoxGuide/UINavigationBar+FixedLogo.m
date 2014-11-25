//
//  UINavigationBar+FixedLogo.m
//  BoxGuide
//
//  Created by Martin Heras on 11/2/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "UINavigationBar+FixedLogo.h"
#import "UIColor+BoxGuide.h"
#import <JRSwizzle/JRSwizzle.h>

static const CGFloat kNavigtionBarFixedHeight = 44.0f;

@implementation UINavigationBar (FixedLogo)

+ (void)load {
    
    /*
    NSError *error = nil;
    [self jr_swizzleMethod:@selector(initWithFrame:) withMethod:@selector(bg_initWithFrame:) error:&error];
    NSAssert(error == nil, @"An error occurred when swizzling UINavigationBar.");
    [self jr_swizzleMethod:@selector(sizeThatFits:) withMethod:@selector(bg_sizeThatFits:) error:&error];
    NSAssert(error == nil, @"An error occurred when swizzling UINavigationBar.");*/
}

- (id)bg_initWithFrame:(CGRect)frame {
    
    UINavigationBar *navBar = [self bg_initWithFrame:frame];
    if (navBar != nil) {
        
        UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        logoLabel.text = [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
        logoLabel.font = [UIFont fontWithName:@"Lobster1.4" size:22.0f]; // TODO: Create method to create this font.
        logoLabel.textColor = [UIColor bg_logoTextColor];
        [navBar addSubview:logoLabel];
        
        [logoLabel sizeToFit];
        logoLabel.frame = CGRectMake((CGRectGetWidth(navBar.frame) - CGRectGetWidth(logoLabel.frame)) / 2.0f, 0.0f, CGRectGetWidth(logoLabel.frame), CGRectGetHeight(logoLabel.frame));
        logoLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }

    return navBar;
}

- (CGSize)bg_sizeThatFits:(CGSize)size
{
    CGSize newSize = CGSizeMake(CGRectGetWidth(self.frame), kNavigtionBarFixedHeight);
    return newSize;
}

@end
