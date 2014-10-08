//
//  BGViewController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/7/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGViewController.h"
#import <RESideMenu.h>
#import <NSString+FontAwesome.h>
#import <UIFont+FontAwesome.h>

@interface BGViewController ()

@end

@implementation BGViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController.viewControllers firstObject] == self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-list"] style:UIBarButtonItemStylePlain target:self action:@selector(onRootMenuButtonTouch)];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontAwesomeFontOfSize:17.0]} forState:UIControlStateNormal];
    }
}

- (void)onRootMenuButtonTouch {
    [self.sideMenuViewController presentLeftMenuViewController];
}

@end
