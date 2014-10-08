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
#import <RESideMenu.h>

static NSString * const kOptionSeriesKey = @"Series";
static NSString * const kOptionListsKey = @"Lists";
static NSString * const kOptionMoviesKey = @"Movies";
static NSString * const kOptionStatisticsKey = @"Statistics";
static NSString * const kOptionConfigurationKey = @"Configuration";
static NSString * const kOptionHelpKey = @"Help";

@interface BGRootMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *optionsPerSection;
@property (nonatomic, strong) NSDictionary *viewControllerPerOption;

@end

@implementation BGRootMenuViewController

- (id)init {
    self = [super init];
    if (self) {
        
        // TODO: Remove this.
        BGDummyViewController *dummyViewController = [[BGDummyViewController alloc] init];
        
        self.viewControllerPerOption = @{kOptionSeriesKey : dummyViewController, kOptionListsKey : dummyViewController, kOptionMoviesKey : dummyViewController, kOptionStatisticsKey : dummyViewController, kOptionConfigurationKey : dummyViewController, kOptionHelpKey : dummyViewController};
        self.optionsPerSection = @[@[kOptionSeriesKey, kOptionListsKey, kOptionMoviesKey, kOptionStatisticsKey], @[kOptionConfigurationKey, kOptionHelpKey]];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BGRootMenuTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([BGRootMenuTableViewCell class])];
}

- (UIViewController *)defaultViewController {
    return [[UINavigationController alloc] initWithRootViewController:self.viewControllerPerOption[[[self.optionsPerSection firstObject] firstObject]]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.optionsPerSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.optionsPerSection[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BGTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BGRootMenuTableViewCell class])];
    cell.textLabel.text = self.optionsPerSection[indexPath.section][indexPath.row]; // TODO: I18N
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BGViewController *viewController = self.viewControllerPerOption[self.optionsPerSection[indexPath.section][indexPath.row]];
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.sideMenuViewController setContentViewController:contentNavigationController animated:YES];
}

@end
