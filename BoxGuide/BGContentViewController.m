//
//  BGContentViewController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/18/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGContentViewController.h"
#import <RESideMenu.h>
#import <NSString+FontAwesome.h>
#import <UIFont+FontAwesome.h>

@implementation BGContentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

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
