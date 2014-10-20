//
//  BGAppDelegate.m
//  BoxGuide
//
//  Created by Martin Heras on 10/1/14.
//  Copyright (c) 2014 HSoft. All rights reserved.
//

#import "BGAppDelegate.h"
#import "BGRootMenuViewController.h"
#import "UIColor+BoxGuide.h"
#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/MMDrawerVisualState.h>

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
    
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:[rootMenuViewController defaultViewController] leftDrawerViewController:rootMenuViewController];
    
    [drawerController setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:20]]; // TODO: Magic number.
    
    drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeNone;
    drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeBezelPanningCenterView;
    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll; // TODO: Panning from screen edge may conflict with navigation stack back gesture.
    
    drawerController.shouldStretchDrawer = NO;
    
    drawerController.maximumLeftDrawerWidth = kRootMenuWidth;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = drawerController;
    [self.window makeKeyAndVisible];
}

- (void)setupLookAndFeel {
    [UINavigationBar appearance].barTintColor = [UIColor bg_topBarColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barStyle = UIBarStyleBlackOpaque;
    [UINavigationBar appearance].translucent = NO;
}

@end
