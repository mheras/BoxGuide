//
//  NSString+FontAwesome.h
//  BoxGuide
//
//  Created by Martin Heras on 11/2/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BGFontAwesomeIcon) {
    BGFontAwesomeIconMenu = 0xf0c9,
    BGFontAwesomeIconAddShow = 0xf067
};

@interface NSString (FontAwesome)

+ (NSString *)bg_stringWithFontAwesomeIcon:(BGFontAwesomeIcon)icon;

@end
