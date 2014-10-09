//
//  BGDummyViewController.m
//  BoxGuide
//
//  Created by Martin Heras on 10/8/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGDummyViewController.h"

@interface BGDummyViewController ()

@end

@implementation BGDummyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:drand48() green:drand48() blue:drand48() alpha:1.0f];
}

@end
