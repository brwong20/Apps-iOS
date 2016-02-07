//
//  AppDelegate.m
//  Photo Bombers
//
//  Created by Brian Wong on 8/4/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotosViewController.h"
#import "IntroViewController.h"

#import <SimpleAuth/SimpleAuth.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

//TODO: Create a starting screen to describe app and take in user input for hashtag


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Setting up our instagram client with SimpleAuth
    SimpleAuth.configuration[@"instagram"] = @{
       @"client_id" : @"4b1f665ceb2b4805b80b68138b5be683",
       SimpleAuthRedirectURIKey : @"photobombers://auth/instagram"
    };
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //Creating a class embedded in a nav controller with CODE
    IntroViewController *introVC = [[IntroViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:introVC];
    self.window.rootViewController = navigationController;
    
    //Nav bar customization
    UINavigationBar *navBar = navigationController.navigationBar;
    navBar.barTintColor = [UIColor colorWithRed:242.0/255.0 green:122.0/255.0 blue:87.0/255.0 alpha:1.0];
    navBar.barStyle = UIBarStyleBlackOpaque;
    
    self.window.tintColor = [UIColor whiteColor];//For white bar items
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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

@end
