//
//  BGRootMenuViewController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/7/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGRootMenuViewController.h"
#import "BGRootMenuTableViewCell.h"
#import "BGDummyViewController.h" // TODO: Remove it.
#import "BGShowsAddPopularViewController.h" // TODO: Remove it.
#import "BGShowsViewController.h"
#import "BGShowsUpcomingViewController.h"
#import "BGShowsRecentViewController.h"
#import "BGTabBarController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>

const CGFloat kRootMenuWidth = 150.0f;

static NSString * const kOptionShowsKey = @"RootMenu.Options.Show";
static NSString * const kOptionListsKey = @"RootMenu.Options.Lists";
static NSString * const kOptionMoviesKey = @"RootMenu.Options.Movies";
static NSString * const kOptionStatisticsKey = @"RootMenu.Options.Statistics";
static NSString * const kOptionConfigurationKey = @"RootMenu.Options.Configuration";
static NSString * const kOptionHelpKey = @"RootMenu.Options.Help";

@interface BGRootMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *optionsPerSection;
@property (nonatomic, strong) NSDictionary *viewControllerPerOption;

@end

@implementation BGRootMenuViewController

- (id)init {
    self = [super init];
    if (self) {
        
        self.viewControllerPerOption = @{kOptionShowsKey : [self createShowsTabBarController], kOptionListsKey : [[BGDummyViewController alloc] init], kOptionMoviesKey : [[BGDummyViewController alloc] init], kOptionStatisticsKey : [[BGDummyViewController alloc] init], kOptionConfigurationKey : [[BGDummyViewController alloc] init], kOptionHelpKey : [[BGDummyViewController alloc] init]};
        self.optionsPerSection = @[@[kOptionShowsKey, kOptionListsKey, kOptionMoviesKey, kOptionStatisticsKey], @[kOptionConfigurationKey, kOptionHelpKey]];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BGRootMenuTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([BGRootMenuTableViewCell class])];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    CGFloat statusBarHeight = MIN(CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), CGRectGetWidth([UIApplication sharedApplication].statusBarFrame));
    
    UIEdgeInsets insets = UIEdgeInsetsMake(statusBarHeight, 0.0f, 0.0f, 0.0f);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (UIViewController *)defaultViewController {
    return self.viewControllerPerOption[[[self.optionsPerSection firstObject] firstObject]];
}

- (BGViewController *)createShowsTabBarController {
    BGTabBarController *showsTabBarController = [[BGTabBarController alloc] initWithViewControllers:@[[[UINavigationController alloc] initWithRootViewController:[[BGShowsAddPopularViewController alloc] init]], [[UINavigationController alloc] initWithRootViewController:[[BGShowsViewController alloc] init]], [[UINavigationController alloc] initWithRootViewController:[[BGShowsUpcomingViewController alloc] init]], [[UINavigationController alloc] initWithRootViewController:[[BGShowsRecentViewController alloc] init]]]];
    return showsTabBarController;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.optionsPerSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.optionsPerSection[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BGTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BGRootMenuTableViewCell class])];
    cell.textLabel.text = NSLocalizedString(self.optionsPerSection[indexPath.section][indexPath.row], nil);
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath isEqual:[self.tableView indexPathForSelectedRow]]) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = self.viewControllerPerOption[self.optionsPerSection[indexPath.section][indexPath.row]];
    [self.mm_drawerController setCenterViewController:viewController withCloseAnimation:YES completion:nil];
}

@end
