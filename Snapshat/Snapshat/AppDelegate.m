//
//  AppDelegate.m
//  Snapshat
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Shows launch image for 1.5 seconds
    [NSThread sleepForTimeInterval:1.5];
    
    // Initialize Parse.
    [Parse setApplicationId:@"R79bT73odqw7mg4fLcZZWcL7KnDrHJ1gxEwNx1Hx"
                  clientKey:@"saAPxCvMhPVigQ2hC1TFGzTFhNZvmHqzFg7EczQc"];
    
    [self customizeUserInterface];
    
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

-(void)customizeUserInterface{
    //Customize the nav bar across the app
    
    //Bar color
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"navBarBackground"]  forBarMetrics:UIBarMetricsDefault];
    
    //Bar text color (actually a dictionary of any attributes you want
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    //Bar button color
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    //Tab Bar items - other properties are set in IB (background, tint, selected, etc.)
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    //Since we set the tab bar as our root VC
    UITabBarController *tabController = (UITabBarController*)self.window.rootViewController;
    UITabBar *tabBar = tabController.tabBar;
    
    UITabBarItem *tabInbox = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabFriends = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabCamera = [tabBar.items objectAtIndex:2];
    
    //Instead of the default shading xcode applies, we set the color of the items to always be white
    tabInbox.image = [[UIImage imageNamed:@"inbox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabFriends.image = [[UIImage imageNamed:@"friends"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabCamera.image = [[UIImage imageNamed:@"camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
