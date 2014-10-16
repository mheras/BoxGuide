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

- (void)setPosterUrl:(NSURL *)posterUrl {
    [self.imageView bg_setImageFromURL:posterUrl placeholderImage:nil];
}

- (NSURL *)posterUrl {
    return self.imageView.bg_url;
}

@end
