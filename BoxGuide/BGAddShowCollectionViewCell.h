//
//  BGAddShowCollectionViewCell.h
//  BoxGuide
//
//  Created by Martin Heras on 10/10/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGCollectionViewCell.h"

@interface BGAddShowCollectionViewCell : BGCollectionViewCell

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSURL *backdropUrl;

@end
