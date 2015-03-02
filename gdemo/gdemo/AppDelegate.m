//
//  AppDelegate.m
//  gdemo
//
//  Created by ganjianping on 4/2/15.
//  Copyright (c) 2015 ganjp. All rights reserved.
//

#import "AppDelegate.h"
#import "SimpleTableVC.h"
#import "JpNC.h"
#import "JpApplication.h"
#import "ViewController.h"
#import "JpSystemUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [JpSystemUtil initAppLanguage];
    
    //set Status bar background color
    [[JpApplication sharedManager] initWithPrimaryColor:COLOR_BLUE_PRIMARY darkPrimaryColor:COLOR_BLUE_DARK_PRIMARY lightPrimaryColor:COLOR_BLUE_LIGHT_PRIMARY frontColor:[UIColor whiteColor] backgroundColor:COLOR_BLUE_PRIMARY navBackgroundImageName:@""];
    
    ViewController *simpleTableViewController = [[ViewController alloc] init];
    JpNC *simpleTableNC = [[JpNC alloc] initWithRootViewController:simpleTableViewController];
    [self.window setRootViewController:simpleTableNC];
    
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
