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
#import "ObsDBManager.h"
#import "JpFileUtil.h"
#import "JpSystemUtil.h"

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
    NSString *loginUserId = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID];
    NSString *lastUpdateTimeKey = [loginUserId stringByAppendingString:TABLE_OBM_BOOKING_VEHICLE_ITEM];
    NSString *lastUpdateTimeIntStr = [JpDataUtil getValueFromUDByKey:lastUpdateTimeKey];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (lastUpdateTimeIntStr) {
        NSString *lastUpdateTimeStr = [JpDateUtil getDateTimeStrByMilliSecond:[lastUpdateTimeIntStr longLongValue]];
        [parameters setObject:lastUpdateTimeStr forKey:KEY_START_DATE];
        NSLog(@"%@'s last update date is %@", [JpDataUtil getValueFromUDByKey:KEY_USER_NAME], lastUpdateTimeStr);
    }
    [parameters setObject:@"1.2" forKey:@"version"];
    [self synSignature];
    return [[ObsWebAPIClient sharedClient] GET:[@"free/driver/booking/" stringByAppendingString:[JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID]] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *respondDic = responseObject;
            NSString *result = [respondDic valueForKey:KEY_RESULT];
        
            NSMutableArray *mutableSections = [[NSMutableArray alloc]init];
            NSMutableDictionary *mutaleSectionAndCellsDic = [[NSMutableDictionary alloc] init];
        
            NSString *broadcastBookingVehicleItemIds = [respondDic valueForKey:KEY_BROADCAST_BOOKING_VEHICLE_ITEM_IDS];
            if ([broadcastBookingVehicleItemIds length]>=32) {
                [mutaleSectionAndCellsDic setObject:broadcastBookingVehicleItemIds forKey:KEY_BROADCAST_BOOKING_VEHICLE_ITEM_IDS];
            }
            NSString *batchBroadcastBookingVehicleItemIds = [respondDic valueForKey:KEY_BATCH_BROADCAST_BOOKING_VEHICLE_ITEM_IDS];
            [JpDataUtil saveDataToUDForKey:KEY_BATCH_BROADCAST_BOOKING_VEHICLE_ITEM_IDS value:batchBroadcastBookingVehicleItemIds];
            if ([result isEqualToString:VALUE_SUCCESS]) {
                NSArray *obmBookingItems = [respondDic valueForKeyPath:KEY_DATA];
                NSString *newLastUpdateTimeIntStr = lastUpdateTimeIntStr;
                ObsDBManager *dbManager = [ObsDBManager getSharedInstance];
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
                    [self downloadSignature:[obmBookingItem objectForKey:COLUMN_LEAD_PASSENGER_SIGNATURE_PATH]];
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

+ (void) downloadSignature:(NSString *) signaturePath
{
    @try {
      if (![signaturePath isKindOfClass:[NSNull class]] && [signaturePath length]>10) {
        NSRange range = [signaturePath rangeOfString:@"/" options:NSBackwardsSearch];
        NSString *imageName = [signaturePath substringFromIndex:range.location+1];
        NSString *signatureLocalFullPath = [JpFileUtil getFullPathWithDirName:@"signature"];
        signatureLocalFullPath = [signatureLocalFullPath stringByAppendingPathComponent:imageName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:signatureLocalFullPath]) {
          NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
          AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
          NSString *signtureUrl = [NSString stringWithFormat:@"%@%@", URL_HOST, signaturePath];
          NSURL *URL = [NSURL URLWithString:signtureUrl];
          NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
          NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            //          NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSString *signaturePath = [NSString stringWithFormat:@"file://%@", [JpFileUtil getFullPathWithDirName:@"signature"]];
            NSURL *documentsDirectoryURL = [NSURL URLWithString:signaturePath];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
          } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"File downloaded to: %@", filePath);
          }];
          [downloadTask resume];

        }
      }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

+ (void) synSignature
{
    @try {
        NSMutableArray *signatureInfoArr = [JpDataUtil getArrFromUDByKey:KEY_SIGNATURE_INFOS];
        if (![signatureInfoArr isKindOfClass:[NSNull class]] && [signatureInfoArr count]>0) {
            NSString *signaturePath = [JpFileUtil getFullPathWithDirName:@"signature"];
            for (NSString *signatureInfo in signatureInfoArr) {
                if ([signatureInfo length]>0 && [signatureInfo containsString:@","]) {
                    NSArray *signatureArr = [signatureInfo componentsSeparatedByString:@","];
                    NSString *fullPath = [signaturePath stringByAppendingPathComponent:signatureArr[0]];
                    [ObsWebAPIClient uploadSignature:fullPath imagName:signatureArr[0] bookingVehicleItemId:signatureArr[1]];
                }
            }
        }
    }
    @catch (NSException *exception) {
    
    }
    @finally {
    
    }
}
    
+ (void) uploadSignature:(NSString *)signatureFullPath imagName:(NSString *)imageName bookingVehicleItemId:(NSString *) bookingVehicleItemId
{
    @try {
    NSString *userName = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_NAME];
    NSString *deviceName = [JpSystemUtil getDeviceName];
    NSDictionary *parameters = @{KEY_BOOKING_VEHICLE_ITEM_ID: bookingVehicleItemId, KEY_USER_NAME:userName, @"deviceName":deviceName};
    NSURL *filePath = [NSURL fileURLWithPath:signatureFullPath];
    NSString *urlStr = [URL_HOST stringByAppendingString:@"web/01/uploadSignature"];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"files" fileName:imageName mimeType:@"image/jpeg" error:nil];
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSMutableArray *signatureInfoArr = [JpDataUtil getArrFromUDByKey:KEY_SIGNATURE_INFOS];
            if (![signatureInfoArr isKindOfClass:[NSNull class]] && [signatureInfoArr count]>0) {
                NSString *signatureInfo = [NSString stringWithFormat:@"%@,%@", imageName, bookingVehicleItemId];
                if ([signatureInfoArr indexOfObject:signatureInfo] != NSNotFound) {
                    signatureInfoArr = [signatureInfoArr mutableCopy];
                    [signatureInfoArr removeObject:signatureInfo];
                    if ([signatureInfoArr count]==0) {
                        [JpDataUtil remove:KEY_SIGNATURE_INFOS];
                    } else {
                        [JpDataUtil saveDataToUDForKey:KEY_SIGNATURE_INFOS value:signatureInfoArr];
                    }
                }
            }
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
    }
    @catch (NSException *exception) {
            
    }
    @finally {
            
    }
}

@end
