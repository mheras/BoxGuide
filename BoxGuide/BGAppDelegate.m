//
//  BGAppDelegate.m
//  BoxGuide
//
//  Created by Martin Heras on 10/1/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGAppDelegate.h"
#import <RESideMenu.h>
#import "BGRootMenuViewController.h"

@interface BGAppDelegate ()

@end

@implementation BGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self setupLookAndFeel];
    [self buildMenu];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)buildMenu {
    BGRootMenuViewController *rootMenuViewController = [[BGRootMenuViewController alloc] init];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:[rootMenuViewController defaultViewController] leftMenuViewController:rootMenuViewController rightMenuViewController:nil];
    
    sideMenuViewController.contentViewScaleValue = 0.85;
    sideMenuViewController.bouncesHorizontally = NO;
    sideMenuViewController.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    sideMenuViewController.view.backgroundColor = [UIColor darkGrayColor];
    sideMenuViewController.contentViewShadowEnabled = YES;
    sideMenuViewController.scaleMenuView = NO;
    
    // TODO: Fix this...
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    sideMenuViewController.contentViewInPortraitOffsetCenterX = 80.0f - (UIInterfaceOrientationIsPortrait(orientation) ? CGRectGetWidth([UIScreen mainScreen].bounds) : CGRectGetHeight([UIScreen mainScreen].bounds)) / 2.0f;
    sideMenuViewController.contentViewInLandscapeOffsetCenterX = 80.0f - (UIInterfaceOrientationIsPortrait(orientation) ? CGRectGetHeight([UIScreen mainScreen].bounds) : CGRectGetWidth([UIScreen mainScreen].bounds)) / 2.0f;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = sideMenuViewController;
    [self.window makeKeyAndVisible];
}

- (void)setupLookAndFeel {
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:1 green:0.227 blue:0.176 alpha:1];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barStyle = UIBarStyleBlackOpaque;
}

@end
