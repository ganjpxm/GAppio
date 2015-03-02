// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ObsWebAPIClient.h"
#import "JpDataUtil.h"
#import "JpDateUtil.h"
#import "DBManager.h"

@implementation ObsWebAPIClient

+ (instancetype)sharedClient {
    static ObsWebAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ObsWebAPIClient alloc] initWithBaseURL:[NSURL URLWithString:URL_HOST]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    });
    
    return _sharedClient;
}

+ (NSURLSessionDataTask *)getObmBookingItemsFromServerWithBlock:(void (^)(NSArray *sections, NSDictionary *sectionCellsDic, NSError *error))block {
    NSString *loginUserId = [JpDataUtil getValueFromUDByKey:KEY_USER_ID];
    NSString *lastUpdateTimeKey = [loginUserId stringByAppendingString:TABLE_OBM_BOOKING_VEHICLE_ITEM];
    NSString *lastUpdateTimeIntStr = [JpDataUtil getValueFromUDByKey:lastUpdateTimeKey];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (lastUpdateTimeIntStr) {
        NSString *lastUpdateTimeStr = [JpDateUtil getDateTimeStrByMilliSecond:[lastUpdateTimeIntStr longLongValue]];
        [parameters setObject:lastUpdateTimeStr forKey:KEY_START_DATE];
        NSLog(@"%@'s last update date is %@", [JpDataUtil getValueFromUDByKey:KEY_USER_NAME], lastUpdateTimeStr);
    }
    
    return [[ObsWebAPIClient sharedClient] GET:[@"free/driver/booking/" stringByAppendingString:[JpDataUtil getValueFromUDByKey:KEY_USER_ID]] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *respondDic = responseObject;
            NSString *result = [respondDic valueForKey:KEY_RESULT];
        
            NSMutableArray *mutableSections = [[NSMutableArray alloc]init];
            NSMutableDictionary *mutaleSectionAndCellsDic = [[NSMutableDictionary alloc] init];
        
            NSString *broadcastBookingVehicleItemIds = [respondDic valueForKey:KEY_BROADCAST_BOOKING_VEHICLE_ITEM_IDS];
            if ([broadcastBookingVehicleItemIds length]>=32) {
                [mutaleSectionAndCellsDic setObject:broadcastBookingVehicleItemIds forKey:KEY_BROADCAST_BOOKING_VEHICLE_ITEM_IDS];
            }
        
            if ([result isEqualToString:VALUE_SUCCESS]) {
                NSArray *obmBookingItems = [respondDic valueForKeyPath:KEY_DATA];
                NSString *newLastUpdateTimeIntStr = lastUpdateTimeIntStr;
                DBManager *dbManager = [DBManager getSharedInstance];
                for (NSDictionary *obmBookingItem in obmBookingItems) {
                    NSString *pickupDateIntStr = [obmBookingItem objectForKey:COLUMN_PICKUP_DATE];
                    NSString *pickupTimeStr = [obmBookingItem objectForKey:COLUMN_PICKUP_TIME];
                    if (pickupDateIntStr!=nil && ![pickupDateIntStr isKindOfClass:[NSNull class]] &&
                        pickupTimeStr!=nil && ![pickupTimeStr isKindOfClass:[NSNull class]]) {
                        NSString *pickupDateStr = [JpDateUtil getDateStrByMilliSecond:[pickupDateIntStr longLongValue]];
                        NSString *modifyTimeIntStr = [obmBookingItem objectForKey:COLUMN_MODIFY_TIMESTAMP];
                        if (!newLastUpdateTimeIntStr || [modifyTimeIntStr longLongValue] > [newLastUpdateTimeIntStr longLongValue]){
                            NSLog(@"%@", [JpDateUtil getDateTimeStrByMilliSecond:[modifyTimeIntStr longLongValue]]);
                            newLastUpdateTimeIntStr = modifyTimeIntStr;
                        }
                        if (![mutableSections containsObject:pickupDateStr]) {
                            [mutableSections addObject:pickupDateStr];
                        }
                        if ([mutaleSectionAndCellsDic objectForKey:pickupDateStr]) {
                            [[mutaleSectionAndCellsDic objectForKey:pickupDateStr] addObject:obmBookingItem];
                        } else {
                            NSMutableArray *newObmBookingItems = [[NSMutableArray alloc]init];
                            [newObmBookingItems addObject:obmBookingItem];
                            [mutaleSectionAndCellsDic setObject:newObmBookingItems forKey:pickupDateStr];
                        }
                        NSMutableDictionary *mutableDic= [obmBookingItem mutableCopy];
                        NSString *pickupDateTimeStr = [obmBookingItem objectForKey:COLUMN_PICKUP_DATE_TIME];
                        if (!pickupDateTimeStr || [pickupDateTimeStr isKindOfClass:[NSNull class]]) {
                            pickupDateTimeStr = [NSString stringWithFormat:@"%@ %@", pickupDateStr, pickupTimeStr];
                        
                            NSDateFormatter *formate = [[NSDateFormatter alloc] init];
                            [formate setDateFormat:(@"dd/MM/yyyy HH:mm:ss")];
                            NSDate *date = [formate dateFromString:pickupDateTimeStr];
                            unsigned long long milliSecond = [date timeIntervalSince1970] * 1000;
                            NSString *milliSecondStr = [NSString stringWithFormat:@"%llu", milliSecond];
                            [mutableDic setValue:milliSecondStr forKey:COLUMN_PICKUP_DATE_TIME];
                        }
                        [dbManager insertOrUpdateOneRecord:TABLE_OBM_BOOKING_VEHICLE_ITEM pkColumnName:COLUMN_BOOKING_VEHICLE_ITEM_ID columnValueDic:mutableDic];
                    }
                }
                [JpDataUtil saveDataToUDForKey:lastUpdateTimeKey value:newLastUpdateTimeIntStr];
                NSLog(@"The update date is %@", [JpDateUtil getDateTimeStrByMilliSecond:[newLastUpdateTimeIntStr longLongValue]]);
            }
        
            if (block) {
                block([NSArray arrayWithArray:mutableSections],[NSDictionary dictionaryWithDictionary:mutaleSectionAndCellsDic], nil);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error);
            if (block) {
                block([NSArray array], [NSDictionary dictionary], error);
            }
        }];
}

@end
