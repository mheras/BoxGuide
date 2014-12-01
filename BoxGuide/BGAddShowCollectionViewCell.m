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

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *backdropImageView;

@end

@implementation BGAddShowCollectionViewCell

- (void)prepareForReuse {
    self.backdropUrl = nil;
}

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (NSString *)name {
    return self.nameLabel.text;
}

- (void)setBackdropUrl:(NSURL *)backdropUrl {
    [self.backdropImageView bg_setImageFromURL:backdropUrl placeholderImage:nil];
}

- (NSURL *)backdropUrl {
    return self.backdropImageView.bg_url;
}

@end
