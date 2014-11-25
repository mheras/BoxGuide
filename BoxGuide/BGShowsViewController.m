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
#import "UIFont+BoxGuide.h"
#import "NSString+FontAwesome.h"

@interface BGShowsViewController ()

@end

@implementation BGShowsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(onAddShowButtonTouch:)];
}

- (NSString *)title {
    return NSLocalizedString(@"Shows.Title", nil);
}

- (void)onAddShowButtonTouch:(id)sender {

    BGTabBarController *showsAddTabBarController = [[BGTabBarController alloc] initWithViewControllers:@[[[UINavigationController alloc] initWithRootViewController:[[BGShowsAddPopularViewController alloc] init]], [[UINavigationController alloc] initWithRootViewController:[[BGDummyViewController alloc] init]], [[UINavigationController alloc] initWithRootViewController:[[BGDummyViewController alloc] init]]]];
    
    showsAddTabBarController.title = NSLocalizedString(@"Shows.AddShow", nil);
    
    [self presentViewController:showsAddTabBarController animated:YES completion:nil];
}

@end
