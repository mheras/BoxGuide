//
//  BGContentViewController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/18/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGContentViewController.h"
#import "BGTabBarController.h"
#import "UIFont+BoxGuide.h"
#import "NSString+FontAwesome.h"
#import "UIColor+BoxGuide.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>

@implementation BGContentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    BGViewController *firstViewController = [self.navigationController.viewControllers firstObject];
    if (firstViewController == self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString bg_stringWithFontAwesomeIcon:BGFontAwesomeIconMenu] style:UIBarButtonItemStylePlain target:self action:@selector(onRootMenuButtonTouch)];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont bg_fontAwesomeFontOfSize:17.0]} forState:UIControlStateNormal];
    }
    
    [self setupTitleView];
}

- (void)setupTitleView {
    
    if (self.navigationItem != nil) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = self.title;
        titleLabel.font = [UIFont bg_defaultBoldFontOfSize:12];
        titleLabel.textColor = [UIColor bg_topBarTextColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UIView *titleView = [[UIView alloc] init];
        
        [titleView addSubview:titleLabel];
        
        self.navigationItem.titleView = titleView;
        
        // Size constraints.
        [titleView addConstraint:[NSLayoutConstraint constraintWithItem:titleView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:44.0f]];
        
        // Vertical constraints.
        [titleView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
        
        // Center X constraints.
        [titleView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        
        // Leading / trailing constraints.
        [titleView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:titleView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f]];
        [titleView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:titleView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        CGSize size = [titleView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        titleView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
    }
}

- (void)onRootMenuButtonTouch {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
