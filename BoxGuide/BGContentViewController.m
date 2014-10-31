//
//  BGContentViewController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/18/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGContentViewController.h"
#import "BGTabBarController.h"
#import <FontAwesome+iOS/UIFont+FontAwesome.h>
#import <FontAwesome+iOS/NSString+FontAwesome.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>

@implementation BGContentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    BGViewController *firstViewController = [self.navigationController.viewControllers firstObject];
    if (firstViewController == self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%C", (unichar)0xf0c9] style:UIBarButtonItemStylePlain target:self action:@selector(onRootMenuButtonTouch)];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontAwesomeFontOfSize:17.0]} forState:UIControlStateNormal];
    }
}

- (void)onRootMenuButtonTouch {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
