//
//  BGRootMenuTableViewCell.m
//  BoxGuide
//
//  Created by Martin Heras on 10/8/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGRootMenuTableViewCell.h"
#import "UIColor+BoxGuide.h"

@implementation BGRootMenuTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
    
    self.textLabel.textColor = selected ? [UIColor bg_rootMenuOptionSelectedColor] : [UIColor bg_rootMenuOptionDeselectedColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];

    self.textLabel.textColor = highlighted || self.isSelected ? [UIColor bg_rootMenuOptionSelectedColor] : [UIColor bg_rootMenuOptionDeselectedColor];
}

@end
