//
//  BGTabBarController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/28/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGTabBarController.h"
#import "UIColor+BoxGuide.h"
#import <HMSegmentedControl/HMSegmentedControl.h>

@interface HMSegmentedControl (Notify)

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify;

@end

@interface BGTabBarController ()

@property (nonatomic, strong) NSLayoutConstraint *currentViewControllerLeftConstraint;
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSegmentedControl];
    self.selectedIndex = self.startIndex;
}

- (void)hideNavBarHairline {
    for (UIView *firstLevelSubviews in self.navigationController.navigationBar.subviews) {
        for (UIView *secondLevelSubviews in firstLevelSubviews.subviews) {
            if ([secondLevelSubviews isKindOfClass:[UIImageView class]] && secondLevelSubviews.bounds.size.width == self.navigationController.navigationBar.frame.size.width &&
                secondLevelSubviews.bounds.size.height < 2) {
                secondLevelSubviews.hidden = YES;
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideNavBarHairline];
}

- (void)setupSegmentedControl {
    
    self.toolbar = [[UIToolbar alloc] init];
    self.toolbar.translucent = NO;
    self.toolbar.barTintColor = [UIColor bg_topBarBackgroundColor];
    [self.view addSubview:self.toolbar];
    
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (UIViewController *viewController in self.viewControllers) {
        NSString *title = viewController.title;
        [titles addObject:title != nil ? [title uppercaseString] : @""];
    }
    
    UIBarButtonItem *flexibleSpace  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
    self.segmentedControl.layer.cornerRadius = 5.0f;
    self.segmentedControl.clipsToBounds = YES;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    self.segmentedControl.font = [UIFont systemFontOfSize:11.0f];
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    
    self.segmentedControl.backgroundColor = [UIColor bg_tabBarBackgroundColor];
    self.segmentedControl.textColor = [UIColor bg_tabBarTextColor];
    self.segmentedControl.selectionIndicatorColor = [UIColor bg_tabBarSelectedBackgroundColor];
    self.segmentedControl.selectedTextColor = [UIColor bg_tabBarSelectedTextColor];
    self.segmentedControl.selectionIndicatorBoxOpacity = 1.0f;
    
    [self.segmentedControl addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.toolbar.items = @[flexibleSpace, [[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl], flexibleSpace];
    
    // Constraints for the toolbar.
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
    [self.toolbar addConstraint:[NSLayoutConstraint constraintWithItem:self.toolbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:44.0f]];
    
    // Constraints for the segmented control.
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.segmentedControl addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.0f]];
    [self.segmentedControl addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:300.0f]];
}

- (NSArray *)buildConstraintsForViewController:(BGViewController *)viewController {
    return @[[NSLayoutConstraint constraintWithItem:viewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f], [NSLayoutConstraint constraintWithItem:viewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f], [NSLayoutConstraint constraintWithItem:viewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.toolbar attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f], [NSLayoutConstraint constraintWithItem:viewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
}

- (void)segmentedControlIndexChanged:(id)sender {
    
    BGViewController *toViewController = self.viewControllers[self.selectedIndex];
    toViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *constraints = [self buildConstraintsForViewController:toViewController];
    
    [self.navigationItem setRightBarButtonItem:nil animated:NO];
    
    if (self.currentViewController == nil) {
        
        [self addChildViewController:toViewController];
        [self.view addSubview:toViewController.view];
        [self.view addConstraints:constraints];
        [toViewController didMoveToParentViewController:self];
        self.currentViewController = toViewController;
        self.previousSelectedIndex = self.selectedIndex;
        
    } else {
        
        [self.currentViewController willMoveToParentViewController:nil];
        [self addChildViewController:toViewController];
        
        toViewController.view.transform = CGAffineTransformMakeTranslation((self.previousSelectedIndex < self.selectedIndex ? 1 : -1) * CGRectGetWidth(self.currentViewController.view.frame), 0.0f);
        
        self.segmentedControl.userInteractionEnabled = NO;
        
        BGToWeak(self, weakSelf);
        [self transitionFromViewController:self.currentViewController toViewController:toViewController duration:0.15 options:0 animations:^{
            [weakSelf.view addConstraints:constraints];
            toViewController.view.transform = CGAffineTransformIdentity;
            weakSelf.currentViewController.view.transform = CGAffineTransformMakeTranslation((weakSelf.previousSelectedIndex < weakSelf.selectedIndex ? -1 : 1) * CGRectGetWidth(weakSelf.currentViewController.view.frame), 0.0f);
            
        } completion:^(BOOL finished) {
            
            [weakSelf.currentViewController removeFromParentViewController];
            [toViewController didMoveToParentViewController:weakSelf];
            weakSelf.currentViewController = toViewController;
            weakSelf.previousSelectedIndex = weakSelf.selectedIndex;
            weakSelf.segmentedControl.userInteractionEnabled = YES;
            
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
