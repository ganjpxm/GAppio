//
//  AppDelegate.m
//  obs
//
//  Created by ganjianping on 4/2/15.
//  Copyright (c) 2015 lt. All rights reserved.
//

#import "AppDelegate.h"
#import "GAI.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Reachability.h"
#import "JpDataUtil.h"
#import "JpSystemUtil.h"
#import "JpApplication.h"
#import "JpConst.h"
#import "ObsTabBC.h"
#import "JpNC.h"
#import "ObsLoginWebVC.h"
#import "ObsWebAPIClient.h"
#import "JpUiUtil.h"
#import "JpLogUtil.h"
#import "UIAlertView+AFNetworking.h"
#import "ObsBookingAlarmListVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GAI sharedInstance].trackUncaughtExceptions = YES;// Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].dispatchInterval = 20;// Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];// Optional: set Logger to VERBOSE for debug information.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-52110558-2"];// Initialize tracker. Replace with your tracking ID.
    
    //---------------------------- Network : reachability ------------------------
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    Reachability * reachability = [Reachability reachabilityWithHostname:URL_REACHABILITY];
    reachability.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Block Says Reachable");
        });
    };
    reachability.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Block Says Unreachable");
        });
    };
    [reachability startNotifier];
    if (reachability.isReachable) {
        [JpDataUtil saveDataToUDForKey:KEY_NETWORK_STATUS  value:VALUE_YES];
    } else {
        [JpDataUtil saveDataToUDForKey:KEY_NETWORK_STATUS  value:VALUE_NO];
    }
    
    [JpSystemUtil initAppLanguage];
    [[JpApplication sharedManager] initWithPrimaryColor:COLOR_BLACK_JP darkPrimaryColor:COLOR_BLACK_JP lightPrimaryColor:COLOR_BLACK_JP frontColor:[UIColor whiteColor] backgroundColor:COLOR_BLACK_JP navBackgroundImageName:@""];
    
    // Push Notification [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    } else {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }

    if (launchOptions) {
        NSDictionary *pushInfoDic = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if (pushInfoDic!=Nil && [pushInfoDic count]>0) {
            NSURLSessionTask *task = [ObsWebAPIClient getObmBookingItemsFromServerWithBlock:^(NSArray *sections, NSDictionary *sectionCellsDic, NSError *error) {
                if (!error) {
                    ObsBookingAlarmListVC *bookingAlarmListVC = [[ObsBookingAlarmListVC alloc] init];
                    JpNC *bookingAlarmListNC = [[JpNC alloc] initWithRootViewController:bookingAlarmListVC];
                    [self.window setRootViewController:bookingAlarmListNC];
                }
            }];
            [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
        }
    }
    
    [JpDataUtil saveDataToUDForKey:KEY_IS_SHOW_BROADCAST value:VALUE_YES];
    NSString *userId = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID];
    if ([userId length]>0) {
        ObsTabBC *obsdTabBC = [[ObsTabBC alloc] init];
        [self.window setRootViewController:obsdTabBC];
    } else {
        ObsLoginWebVC *driverLoginWebVC = [[ObsLoginWebVC alloc] init];
        JpNC *driverLoginWebNC = [[JpNC alloc] initWithRootViewController:driverLoginWebVC];
        [self.window setRootViewController:driverLoginWebNC];
    }
    
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

//#pragma mark - Push notification
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSString * deviceTokenStr = [deviceToken description];
    deviceTokenStr = [deviceTokenStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [JpLogUtil log:@"Device token string is:" append:deviceTokenStr];
    [JpDataUtil saveDataToUDForKey:KEY_DEVICE_TOKEN_OBS value:deviceTokenStr];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [JpLogUtil log:@"Register Remote Notifications error"];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Receive remote notification : %@",userInfo);
    
//    NSDictionary *dic = [userInfo valueForKey:@"aps"];
//    NSString *alertMessage = [dic objectForKey:@"alert"];
//    NSString *bookingVehicleItemId = [userInfo valueForKey:@"content"];
//    [JpDataUtil saveDataToUDForKey:KEY_BOOKING_VEHICLE_ITEM_ID_OBSD value:bookingVehicleItemId];
    
    NSURLSessionTask *task = [ObsWebAPIClient getObmBookingItemsFromServerWithBlock:^(NSArray *sections, NSDictionary *sectionCellsDic, NSError *error) {
        if (!error) {
            ObsBookingAlarmListVC *bookingAlarmListVC = [[ObsBookingAlarmListVC alloc] init];
            JpNC *bookingAlarmListNC = [[JpNC alloc] initWithRootViewController:bookingAlarmListVC];
            [self.window setRootViewController:bookingAlarmListNC];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

//Mutiple task fetch data at background
//- (void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler NS_AVAILABLE_IOS(7_0)
//{
//        UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
//    
//        id fetchViewController = navigationController.topViewController;
//        if ([fetchViewController respondsToSelector:@selector(fetchDataResult:)]) {
//            [fetchViewController fetchDataResult:^(NSError *error, NSArray *results){
//                if (!error) {
//                    if (results.count != 0) {
//                        //Update UI with results.
//                        //Tell system all done.
//                        completionHandler(UIBackgroundFetchResultNewData);
//                    } else {
//                        completionHandler(UIBackgroundFetchResultNoData);
//                    }
//                } else {
//                    completionHandler(UIBackgroundFetchResultFailed);
//                }
//            }];
//        } else {
//            completionHandler(UIBackgroundFetchResultFailed);
//        }
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex==1) {
//        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//        NSString *userCd = [JpDataUtil getValueFromUDByKey:KEY_USER_CD_OBSD];
//        NSDictionary *userDic = [JpDataUtil getDicFromUDByKey:userCd];
//        [parameters setObject:[userDic objectForKey:KEY_USER_ID_OBSD] forKey:@"userId"];
//        [parameters setObject:[userDic objectForKey:KEY_USER_NAME_OBSD] forKey:@"userName"];
//        [parameters setObject:[userDic objectForKey:KEY_USER_MOBILE_PHONE_OBSD] forKey:@"mobileNumber"];
//        [parameters setObject:[userDic objectForKey:KEY_USER_EXTEND_ITEMS_OBSD] forKey:@"vehicle"];
//        [parameters setObject:[JpDataUtil getValueFromUDByKey:KEY_BOOKING_VEHICLE_ITEM_ID_OBSD] forKey:@"bookingVehicleItemId"];
//        
//        [[ObsWebAPIClient sharedClient] POST:@"free/booking/accept" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSDictionary *respondDic = responseObject;
//            NSString *result = [respondDic valueForKey:KEY_RESULT];
//            if ([result isEqualToString:VALUE_SCCESS]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBookingTableView" object:nil];
//                [JpUiUtil showAlertWithMessage:@"Thank you, booking added." title:@"Response"];
//            } else if ([result isEqualToString:VALUE_ACCEPTED]) {
//                [JpUiUtil showAlertWithMessage:@"Sorry, job taken!" title:@"Response"];
//            } else {
//                [JpUiUtil showAlertWithMessage:@"Sorry, system error" title:@"Response"];
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            [JpUiUtil showAlertWithMessage:@"Sorry, system error" title:@"Response"];
//        }];
//    }
//}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"url recieved: %@", url);
    NSLog(@"query string: %@", [url query]);
    NSLog(@"host: %@", [url host]);
    NSLog(@"url path: %@", [url path]);
    NSDictionary *dict = [self parseQueryString:[url query]];
    NSLog(@"query dict: %@", dict);
    return YES;
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

-(void)reachabilityChanged:(NSNotification*)notification
{
    Reachability *reachability = [notification object];
    if([reachability isReachable]) {
        [JpDataUtil saveDataToUDForKey:KEY_NETWORK_STATUS  value:VALUE_YES];
    } else {
        [JpDataUtil saveDataToUDForKey:KEY_NETWORK_STATUS  value:VALUE_NO];
    }
}

@end
