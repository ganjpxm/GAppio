//
//  ObscMoreVC.m
//  obsc
//
//  Created by Johnny on 14/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "ObsdMoreVC.h"
#import "DriverLoginWebVC.h"
#import "ObsdData.h"
#import "JpDataUtil.h"
#import "JpDataUtil.h"
#import "JpTableCell.h"
#import "JpUiUtil.h"
#import "ObsWebAPIClient.H"
#import "DBManager.h"
#import "JpNC.h"

@interface ObsdMoreVC ()

@end

@implementation ObsdMoreVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[GoogleAnalyticsUtil sendScreen:SCREEN_MORE];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.sections = [[NSMutableArray alloc] initWithArray:[@"Setting,Product,Account" componentsSeparatedByString:@","]];
        NSDictionary *mmDrawerSectionCellDic = @{@"Setting": @[@{@"text":@"Push Notification"},@{@"text":@"Clear Booking Data"}],@"Product": @[@{@"text":@"About"}],@"Account": @[@{@"text":@"Logout"}]};
        self.sectionCellsDic = [mmDrawerSectionCellDic mutableCopy];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"Left did appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"Left will disappear");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"Left did disappear");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (JpTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JpTableCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            NSString *usePushNotification = [JpDataUtil getValueFromUDByKey:KEY_PUSH_NOTIFICATION_OBSD];
            if ([usePushNotification isEqualToString:VALUE_YES]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            } else {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionName = [self.sections objectAtIndex:indexPath.section];
    NSMutableArray *obmBookingItems= [self.sectionCellsDic objectForKey:sectionName];
    NSDictionary *obmBookingItem = [obmBookingItems objectAtIndex:indexPath.row];
    NSString *cellName = [obmBookingItem objectForKey:@"text"];
    
    if ([sectionName isEqualToString:@"Setting"]) {
        if ([@"Push Notification" isEqualToString:cellName]) {
            if ([[JpDataUtil getValueFromUDByKey:KEY_NETWORK_STATUS_OBSD] isEqualToString:VALUE_YES]) {
            NSString *usePushNotification = [JpDataUtil getValueFromUDByKey:KEY_PUSH_NOTIFICATION_OBSD];
            if (!usePushNotification) {
                usePushNotification = VALUE_NO;
            }
            NSString *deviceToken = [JpDataUtil getValueFromUDByKey:KEY_DEVICE_TOKEN_OBSD];
            
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:[JpDataUtil getDicFromUDByKey:KEY_USER_ID_OBSD] forKey:@"userId"];
            [parameters setObject:deviceToken forKey:@"deviceToken"];
            [parameters setObject:usePushNotification forKey:@"usePushNotification"];
            [parameters setObject:@"iOS" forKey:@"platform"];
            
            [[ObsWebAPIClient sharedClient] GET:@"free/device/regist" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                NSDictionary *respondDic = responseObject;
                NSString *result = [respondDic valueForKey:KEY_RESULT];
                if ([VALUE_SCCESS isEqualToString:result]) {
                    if ([usePushNotification isEqualToString:VALUE_YES]) {
                        [JpDataUtil saveDataToUDForKey:KEY_PUSH_NOTIFICATION_OBSD value:VALUE_NO];
                    } else {
                        [JpDataUtil saveDataToUDForKey:KEY_PUSH_NOTIFICATION_OBSD value:VALUE_YES];
                    }
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    [JpUiUtil showAlertWithMessage:@"Success" title:@"Alert"];
                } else {
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    [JpUiUtil showAlertWithMessage:@"Fail" title:@"Alert"];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                [JpUiUtil showAlertWithMessage:@"Fail" title:@"Alert"];
            }];
            } else {
                [JpUiUtil showAlertWithMessage:@"Network is not available" title:@"Alert"];
            }
            
        } else if ([@"Clear Booking Data" isEqualToString:cellName]) {
            
            NSString *loginUserId = [JpDataUtil getValueFromUDByKey:KEY_USER_ID_OBSD];
            NSString *lastUpdateTimeKey = [loginUserId stringByAppendingString:TABLE_OBM_BOOKING_VEHICLE_ITEM];
            [JpDataUtil saveDataToUDForKey:lastUpdateTimeKey value:nil];
            
            DBManager *dbManager = [DBManager getSharedInstance];
            [dbManager deleteRecords:TABLE_OBM_BOOKING_VEHICLE_ITEM];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBookingTableView" object:nil];
            [JpUiUtil showAlertWithMessage:@"Success" title:@""];
        }
    } else if ([sectionName isEqualToString:@"Account"]) {
        if ([@"Logout" isEqualToString:cellName]) {
            [JpDataUtil saveDataToUDForKey:KEY_USER_ID_OBSD value:@""];
            [JpDataUtil saveDataToUDForKey:KEY_USER_CD_OBSD value:@""];
            [JpDataUtil saveDataToUDForKey:KEY_USER_NAME_OBSD value:@""];
            
            DriverLoginWebVC *driverLoginWebVC = [[DriverLoginWebVC alloc] init];
            JpNC *driverLoginWebNC = [[JpNC alloc] initWithRootViewController:driverLoginWebVC];
            [self presentViewController:driverLoginWebNC animated:YES completion:nil];
        }
    } else if ([sectionName isEqualToString:@"Product"]) {
        if ([@"About" isEqualToString:cellName]) {
            [JpUiUtil showAlertWithMessage:@"Version : 0.1.0" title:@"Driver App"];
        }
    } else {
       [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

@end
