//
//  BGGontentBackgroundView.m
//  BoxGuide
//
//  Created by Martin Heras on 10/18/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGGontentBackgroundView.h"

@implementation BGGontentBackgroundView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupGradientLayer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGradientLayer];
    }
    return self;
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)setupGradientLayer {
    
    self.layer.frame = self.bounds;
    ((CAGradientLayer *)self.layer).colors = @[(id)[UIColor colorWithRed:0.859 green:0.867 blue:0.871 alpha:1].CGColor, (id)[UIColor colorWithRed:0.537 green:0.549 blue:0.565 alpha:1].CGColor];
}

@end
