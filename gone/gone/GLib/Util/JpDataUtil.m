//
//  SystemUtil.m
//  JpLib
//
//  Created by Johnny on 26/12/13.
//  Copyright (c) 2013 dbs. All rights reserved.
//

#import "JpDataUtil.h"
#import "NSString+Jp.h"
#import "JpLogUtil.h"

@implementation JpDataUtil

+ (void)saveDataToUDForKey:(NSString*)key value:(NSObject*)value
{
    // Save the data
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
    [JpLogUtil log:@"Saving to NSUserDefault is " append:key  append:@":" append:value];
}

+ (NSString*)getValueFromUDByKey: (NSString*)key
{
    if ([key isEmpty]) {
        return nil;
    } else {
        NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *loadstring = [userDefaults objectForKey:key];
        return loadstring;
    }
}

+ (NSDictionary*)getDicFromUDByKey: (NSString*)key
{
    if ([key isEmpty]) {
        return nil;
    } else {
        NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [userDefaults objectForKey:key];
        return dic;
    }
}

//Json
+ (NSArray *) getJsonArr:(id)aJsonStr
{
    NSData *responseData = [NSJSONSerialization dataWithJSONObject:aJsonStr options:NSJSONWritingPrettyPrinted error:nil];
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    return jsonArr;
}

@end
