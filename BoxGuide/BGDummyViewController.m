//
//  BGDummyViewController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/8/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGDummyViewController.h"
#import "UIFont+BoxGuide.h"
#import "NSString+FontAwesome.h"

static NSInteger instanceCounter = 0;

@interface BGDummyViewController ()

@property (nonatomic, assign) NSInteger instanceNumber;

@end

@implementation BGDummyViewController

- (id)init {
    self = [super init];
    if (self) {
        self.instanceNumber = instanceCounter++;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:drand48() green:drand48() blue:drand48() alpha:1.0f];
}

- (NSString *)title {
    return [NSString stringWithFormat:@"Dummy %ld", self.instanceNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear: %ld", self.instanceNumber);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear: %ld", self.instanceNumber);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear: %ld", self.instanceNumber);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear: %ld", self.instanceNumber);
}

- (IBAction)onPushButtonTouch:(id)sender {
    [self.navigationController pushViewController:[[BGDummyViewController alloc] init] animated:YES];
}

@end
