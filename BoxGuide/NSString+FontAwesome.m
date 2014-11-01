//
//  NSString+FontAwesome.m
//  BoxGuide
//
//  Created by Martin Heras on 11/2/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "NSString+FontAwesome.h"

@implementation NSString (FontAwesome)

+ (NSString *)bg_stringWithFontAwesomeIcon:(BGFontAwesomeIcon)icon {
    return [NSString stringWithFormat:@"%C", (unichar)icon];
}

@end
