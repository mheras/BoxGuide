//
//  BGAddShowCollectionViewCell.m
//  BoxGuide
//
//  Created by Martin Heras on 10/10/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGAddShowCollectionViewCell.h"
#import "UIImageView+URL.h"

@interface BGAddShowCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation BGAddShowCollectionViewCell

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setPosterImageUrl:(NSURL *)posterImageUrl {
    [self.imageView bg_setImageFromURL:posterImageUrl placeholderImage:nil];
}

- (NSURL *)posterImageUrl {
    return self.imageView.bg_url;
}

@end
