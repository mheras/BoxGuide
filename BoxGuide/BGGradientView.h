//
//  BGGradientView.h
//  BoxGuide
//
//  Created by Martin Heras on 10/18/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface BGGradientView : UIView

@property (nonatomic, strong) IBInspectable UIColor *firstColor;
@property (nonatomic, strong) IBInspectable UIColor *lastColor;

@end
