//
//  UIImageView+URL.h
//  BoxGuide
//
//  Created by Martin Heras on 10/11/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (URL)

- (void)bg_setImageFromURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;
- (NSURL *)bg_url;
- (void)bg_cancelRequestOperation;

@end
