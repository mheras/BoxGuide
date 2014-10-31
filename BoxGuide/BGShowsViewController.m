//
//  BGShowsViewController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/31/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGShowsViewController.h"
#import "BGShowsAddPopularViewController.h"
#import "BGTabBarController.h"
#import "BGDummyViewController.h" // TODO: Remove.
#import <FontAwesome+iOS/UIFont+FontAwesome.h>
#import <FontAwesome+iOS/NSString+FontAwesome.h>

@interface BGShowsViewController ()

@end

@implementation BGShowsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [self.parentViewController.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%C", (unichar)0xf0fe] style:UIBarButtonItemStylePlain target:self action:@selector(onAddShowButtonTouch:)] animated:NO];
    [self.parentViewController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontAwesomeFontOfSize:17.0]} forState:UIControlStateNormal];
    [CATransaction commit];
}

- (NSString *)title {
    return NSLocalizedString(@"Shows.Title", nil);
}

- (void)onAddShowButtonTouch:(id)sender {
    
    BGTabBarController *showsAddTabBarController = [[BGTabBarController alloc] initWithViewControllers:@[[[BGShowsAddPopularViewController alloc] init], [[BGDummyViewController alloc] init], [[BGDummyViewController alloc] init]]];
    
    showsAddTabBarController.title = NSLocalizedString(@"Shows.AddShow", nil);
    
    [self.navigationController pushViewController:showsAddTabBarController animated:YES];
}

@end
