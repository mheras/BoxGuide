//
//  BGTabBarController.h
//  BoxGuide
//
//  Created by Martin Heras on 10/28/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGContentViewController.h"

@interface BGTabBarController : BGContentViewController

@property (nonatomic, strong, readonly) NSArray *viewControllers;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign, readonly) CGFloat toolbarHeight;

- (id)initWithViewControllers:(NSArray *)viewControllers;
- (id)initWithViewControllers:(NSArray *)viewControllers startIndex:(NSInteger)startIndex;

@end

@interface UIViewController (BGTabBarController)

@property (nonatomic, strong, readonly) BGTabBarController *bg_tabBarController;

@end