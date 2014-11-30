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
    
    // Removes the text from the Back button.
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    
    BGViewController *firstViewController = [self.navigationController.viewControllers firstObject];
    // If it's the first in the navigation stack...
    if (firstViewController == self) {
        if ([[self findFurthestParent:self] presentingViewController] != nil) {
            // ...and it's being presented, show the cancel button.
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Content.Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButtonTouch)];
        } else {
            // ...and it's not being presented, show the menu button.
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString bg_stringWithFontAwesomeIcon:BGFontAwesomeIconMenu] style:UIBarButtonItemStylePlain target:self action:@selector(onRootMenuButtonTouch)];
            [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont bg_fontAwesomeFontOfSize:17.0]} forState:UIControlStateNormal];
        }
    }
}

- (UIViewController *)findFurthestParent:(UIViewController *)viewController {
    if (viewController.parentViewController == nil) {
        return viewController;
    } else {
        return [self findFurthestParent:viewController.parentViewController];
    }
}

- (void)onRootMenuButtonTouch {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)onCancelButtonTouch {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
