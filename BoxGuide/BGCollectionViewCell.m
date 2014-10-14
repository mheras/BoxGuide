//
//  BGCollectionViewCell.m
//  BoxGuide
//
//  Created by Martin Heras on 10/13/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGCollectionViewCell.h"

@implementation BGCollectionViewCell

- (void)setBounds:(CGRect)bounds {
    // The following fixes a bug:
    // http://stackoverflow.com/a/25768375/2334509
    // http://stackoverflow.com/a/25791759/2334509
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

@end
