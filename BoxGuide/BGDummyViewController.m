//
//  BGDummyViewController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/8/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGDummyViewController.h"

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
    return [NSString stringWithFormat:@"Dummy %d", self.instanceNumber];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear: %d", self.instanceNumber);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear: %d", self.instanceNumber);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear: %d", self.instanceNumber);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear: %d", self.instanceNumber);
}

- (IBAction)onPushButtonTouch:(id)sender {
    [self.navigationController pushViewController:[[BGDummyViewController alloc] init] animated:YES];
}

@end
