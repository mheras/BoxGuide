//
//  BGTabBarController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/28/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGTabBarController.h"
#import <HMSegmentedControl/HMSegmentedControl.h>

@interface HMSegmentedControl (Notify)

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify;

@end

@interface BGTabBarController ()

@property (nonatomic, strong) NSLayoutConstraint *currentViewControllerLeftConstraint;
@property (nonatomic, weak) BGViewController *currentViewController;

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
    
    [self setupSegmentedControl];
    self.selectedIndex = self.startIndex;
}

- (void)setupSegmentedControl {
    
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (UIViewController *viewController in self.viewControllers) {
        NSString *title = viewController.title;
        [titles addObject:title != nil ? title : @""];
    }
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.segmentedControl];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
    [self.segmentedControl addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50.0f]];
    
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    [self.segmentedControl addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
}

- (NSArray *)buildConstraintsForViewController:(BGViewController *)viewController {
    return @[[NSLayoutConstraint constraintWithItem:viewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f], [NSLayoutConstraint constraintWithItem:viewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f], [NSLayoutConstraint constraintWithItem:viewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.segmentedControl attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f], [NSLayoutConstraint constraintWithItem:viewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
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
