//
//  ObscMoreVC.m
//  obsc
//
//  Created by Johnny on 14/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "ObsMoreVC.h"
#import "ObsLoginWebVC.h"
#import "ObsData.h"
#import "JpDataUtil.h"
#import "JpDataUtil.h"
#import "JpTableCell.h"
#import "JpUiUtil.h"
#import "ObsWebAPIClient.H"
#import "ObsDBManager.h"
#import "JpNC.h"
#import "UIAlertView+AFNetworking.h"
#import "JpConst.h"
#import "JpFileUtil.h"

@interface ObsMoreVC ()

@end

@implementation ObsMoreVC

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
        NSDictionary *mmDrawerSectionCellDic = @{@"Setting": @[@{@"text":@"Open booking system website"},@{@"text":@"Reload booking data"}],@"Product": @[@{@"text":@"About"}],@"Account": @[@{@"text":@"Logout"}]};
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
    [self.view setBackgroundColor:COLOR_GRAY_LIGHT_PRIMARY];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (JpTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JpTableCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
//    if (indexPath.section==0) {
//        if (indexPath.row==0) {
//            NSString *usePushNotification = [JpDataUtil getValueFromUDByKey:KEY_PUSH_NOTIFICATION_OBSD];
//            if ([usePushNotification isEqualToString:VALUE_YES]) {
//                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//            } else {
//                [cell setAccessoryType:UITableViewCellAccessoryNone];
//            }
//        }
//    }
//    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:245.0/256.0 green:245.0/256.0 blue:245.0/256.0 alpha:1];
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionName = [self.sections objectAtIndex:indexPath.section];
    NSMutableArray *obmBookingItems= [self.sectionCellsDic objectForKey:sectionName];
    NSDictionary *obmBookingItem = [obmBookingItems objectAtIndex:indexPath.row];
    NSString *cellName = [obmBookingItem objectForKey:@"text"];
    
    if ([sectionName isEqualToString:@"Setting"]) {
        if ([@"Open booking system website" isEqualToString:cellName]) {
            NSString *userId = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID];
            NSString *websiteUrl = [NSString stringWithFormat:@"%@01/driver/login/%@", URL_HOST, userId];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:websiteUrl]];
        } else if ([@"Reload booking data" isEqualToString:cellName]) {
            [self showConfirmDialog:@"Are you confirm to reload booking data?" tag:1];
        }
    } else if ([sectionName isEqualToString:@"Account"]) {
        if ([@"Logout" isEqualToString:cellName]) {
            [self showConfirmDialog:@"Are you confirm to logout?" tag:2];
        }
    } else if ([sectionName isEqualToString:@"Product"]) {
        if ([@"About" isEqualToString:cellName]) {
            [JpUiUtil showAlertWithMessage:@"Version : 1.2.0" title:@"Limousine Transport"];
        }
    } else {
       [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)showConfirmDialog:(NSString *)message tag:(int)tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Confirm", nil];
    alertView.tag = tag;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"Cancel" pressed
            
            break;
        case 1: //"Confirm" pressed
            if (alertView.tag==1) { //Reload booking data
//                if ([[JpDataUtil getValueFromUDByKey:KEY_NETWORK_STATUS] isEqualToString:VALUE_YES]) {
                    NSString *loginUserId = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID];
                    NSString *lastUpdateTimeKey = [loginUserId stringByAppendingString:TABLE_OBM_BOOKING_VEHICLE_ITEM];
                    [JpDataUtil saveDataToUDForKey:lastUpdateTimeKey value:nil];
                    ObsDBManager *dbManager = [ObsDBManager getSharedInstance];
                    [dbManager deleteRecords:TABLE_OBM_BOOKING_VEHICLE_ITEM];
                
                    NSURLSessionTask *task = [ObsWebAPIClient getObmBookingItemsFromServerWithBlock:^(NSArray *sections, NSDictionary *sectionCellsDic, NSError *error) {
                        if (!error) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBookingTableView" object:nil];
                            [JpUiUtil showAlertWithMessage:@"Success" title:@""];
                        } else {
                            [JpUiUtil showAlertWithMessage:@"Fail" title:@"Alert"];
                        }
                    }];
                    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
//                } else {
//                    [JpUiUtil showAlertWithMessage:@"Network is not available" title:@"Alert"];
//                }
            } else if (alertView.tag==2) {//logout
                [self unregistDevice];
                NSString *deviceToken = [JpDataUtil getValueFromUDByKey:KEY_DEVICE_TOKEN_OBS];
                ObsDBManager *dbManager = [ObsDBManager getSharedInstance];
                [dbManager deleteRecords:TABLE_OBM_BOOKING_VEHICLE_ITEM];
                [JpDataUtil resetDefaults];
                [JpDataUtil saveDataToUDForKey:KEY_DEVICE_TOKEN_OBS value:deviceToken];
                [JpFileUtil deleteMyDocsDirectory:@"signature"];
                
                ObsLoginWebVC *driverLoginWebVC = [[ObsLoginWebVC alloc] init];
                JpNC *driverLoginWebNC = [[JpNC alloc] initWithRootViewController:driverLoginWebVC];
                [self presentViewController:driverLoginWebNC animated:YES completion:nil];
            }
            break;
    }
}

- (void)unregistDevice
{
    if ([[JpDataUtil getValueFromUDByKey:KEY_NETWORK_STATUS] isEqualToString:VALUE_YES]) {
        NSString *deviceToken = [JpDataUtil getValueFromUDByKey:KEY_DEVICE_TOKEN_OBS];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[JpDataUtil getDicFromUDByKey:KEY_OBS_USER_ID] forKey:@"userId"];
        [parameters setObject:deviceToken forKey:@"deviceToken"];
        [parameters setObject:@"iOS" forKey:@"platform"];
        [parameters setObject:VALUE_NO forKey:@"usePushNotification"];
        
        [parameters setObject:[UIDevice currentDevice].systemVersion forKey:@"osVersion"];
        [parameters setObject:@"Apple" forKey:@"deviceBrand"];
        [parameters setObject:[UIDevice currentDevice].model forKey:@"deviceModel"];
        
        [[ObsWebAPIClient sharedClient] GET:@"free/device/regist" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *respondDic = responseObject;
            NSString *result = [respondDic valueForKey:KEY_RESULT];
            if ([VALUE_SUCCESS isEqualToString:result]) {
                [JpDataUtil saveDataToUDForKey:KEY_IS_REGIST_DEVICE_OBS value:VALUE_NO];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

@end
