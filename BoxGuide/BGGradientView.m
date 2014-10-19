//
//  BGGradientView.m
//  BoxGuide
//
//  Created by Martin Heras on 10/18/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGGradientView.h"
#import "UIColor+BoxGuide.h"

@implementation BGGradientView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.frame = self.bounds;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.frame = self.bounds;
    }
    return self;
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)setupGradientLayer {
    
    UIColor *firstColor = self.firstColor;
    UIColor *lastColor = self.lastColor;
    
    if (!firstColor) {
        firstColor = self.backgroundColor ? self.backgroundColor : [UIColor blackColor];
    }
    if (!lastColor) {
        lastColor = self.backgroundColor ? self.backgroundColor : [UIColor blackColor];
    }
    
    ((CAGradientLayer *)self.layer).colors = @[(id)[firstColor CGColor], (id)[lastColor CGColor]];
}

- (void)setFirstColor:(UIColor *)firstColor {
    _firstColor = firstColor;
    [self setupGradientLayer];
}

- (void)setLastColor:(UIColor *)lastColor {
    _lastColor = lastColor;
    [self setupGradientLayer];
}

@end
