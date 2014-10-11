//
//  BGAddShowCollectionViewCell.m
//  BoxGuide
//
//  Created by Martin Heras on 10/10/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGAddShowCollectionViewCell.h"

@interface BGAddShowCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation BGAddShowCollectionViewCell

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString *)title {
    return self.titleLabel.text;
}

@end
