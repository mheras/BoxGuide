//
//  BGTabBarController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/28/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGTabBarController.h"
#import "UIColor+BoxGuide.h"
#import "UIFont+BoxGuide.h"
#import <HMSegmentedControl/HMSegmentedControl.h>

@interface HMSegmentedControl (Notify)

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify;

@end

@interface BGTabBarController ()

@property (nonatomic, weak) BGViewController *currentViewController;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *viewControllers;

@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger previousSelectedIndex;

@end

@implementation BGTabBarController

- (id)initWithViewControllers:(NSArray *)viewControllers {
    return [self initWithViewControllers:viewControllers startIndex:0];
}

- (id)initWithViewControllers:(NSArray *)viewControllers startIndex:(NSInteger)startIndex {
    
    NSAssert(viewControllers.count > 0, @"At least one view controller must be given.");
    
    self = [super init];
    if (self) {
        self.viewControllers = viewControllers;
        self.startIndex = startIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSegmentedControl];
    self.selectedIndex = self.startIndex;
}

- (void)setupSegmentedControl {
    
    self.toolbar = [[UIToolbar alloc] init];
    self.toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    // Add the toolbar to the view.
    [self.view addSubview:self.toolbar];
    
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (UIViewController *viewController in self.viewControllers) {
        NSString *title = viewController.title;
        [titles addObject:title != nil ? [title uppercaseString] : @""];
    }
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
    self.segmentedControl.font = [UIFont bg_defaultFontOfSize:11.0f];
    //self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.textColor = [UIColor bg_tabBarTextColor];
    self.segmentedControl.selectionIndicatorColor = [UIColor bg_tabBarSelectedBackgroundColor];
    self.segmentedControl.selectedTextColor = [UIColor bg_tabBarSelectedTextColor];
    self.segmentedControl.selectionIndicatorBoxOpacity = 0.0f;
    
    [self.segmentedControl addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Constraints for the toolbar.
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbar]|" options:0 metrics:nil views:@{@"toolbar" : self.toolbar}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
    [self.toolbar addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:44.0f]];
    
    [self.toolbar addSubview:self.segmentedControl];
    
    // Constraints for the segmented control.
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[segmentedControl(segmentedControlWidth)]" options:0 metrics:@{@"segmentedControlWidth" : @320} views:@{@"segmentedControl" : self.segmentedControl}]];
    [self.toolbar addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.toolbar attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[segmentedControl]|" options:0 metrics:nil views:@{@"segmentedControl" : self.segmentedControl}]];
}

- (NSArray *)buildConstraintsForViewController:(BGViewController *)viewController {
    
    return [[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[newView]|" options:0 metrics:nil views:@{@"newView" : viewController.view}] arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[newView]|" options:0 metrics:nil views:@{@"newView" : viewController.view}]];
}

- (void)segmentedControlIndexChanged:(id)sender {
    
    BGViewController *toViewController = self.viewControllers[self.selectedIndex];
    toViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.navigationItem setRightBarButtonItem:nil animated:NO];
    
    if (self.currentViewController == nil) {
        
        [self addChildViewController:toViewController];
        [self.view addSubview:toViewController.view];
        [self.view addConstraints:[self buildConstraintsForViewController:toViewController]];
        [self.view bringSubviewToFront:self.toolbar];
        [toViewController didMoveToParentViewController:self];
        self.currentViewController = toViewController;
        self.previousSelectedIndex = self.selectedIndex;
        
    } else {
        
        [self addChildViewController:toViewController];
        [toViewController beginAppearanceTransition:YES animated:YES];
        
        [self.currentViewController beginAppearanceTransition:NO animated:YES];
        [self.currentViewController willMoveToParentViewController:nil];
    
        [self.view addSubview:toViewController.view];
        [self.view addConstraints:[self buildConstraintsForViewController:toViewController]];
        
        [self.view bringSubviewToFront:self.toolbar];

        toViewController.view.transform = CGAffineTransformMakeTranslation((self.previousSelectedIndex < self.selectedIndex ? 1 : -1) * CGRectGetWidth(self.currentViewController.view.frame), 0.0f);
        [self.view layoutIfNeeded];
        
        self.segmentedControl.userInteractionEnabled = NO;
        
        BGToWeak(self, weakSelf);
        [UIView animateWithDuration:0.15f delay:0 options:0 animations:^{
            toViewController.view.transform = CGAffineTransformIdentity;
            weakSelf.currentViewController.view.transform = CGAffineTransformMakeTranslation((weakSelf.previousSelectedIndex < weakSelf.selectedIndex ? -1 : 1) * CGRectGetWidth(weakSelf.currentViewController.view.frame), 0.0f);
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [toViewController didMoveToParentViewController:weakSelf];
            [weakSelf.currentViewController.view removeFromSuperview];
            [weakSelf.currentViewController removeFromParentViewController];
            [weakSelf.currentViewController endAppearanceTransition];
            weakSelf.currentViewController = toViewController;
            weakSelf.previousSelectedIndex = weakSelf.selectedIndex;
            weakSelf.segmentedControl.userInteractionEnabled = YES;
            [toViewController endAppearanceTransition];
        }];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    NSAssert(selectedIndex >= 0 && selectedIndex < self.viewControllers.count, @"Selected index should be within the range of the view controllers.");
    [self.segmentedControl setSelectedSegmentIndex:selectedIndex animated:animated notify:YES];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:YES];
}

- (NSInteger)selectedIndex {
    return self.segmentedControl.selectedSegmentIndex;
}

@end
