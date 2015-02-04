//
//  SystemUtil.m
//  ULOCR
//
//  Created by Johnny on 26/12/13.
//  Copyright (c) 2013 dbs. All rights reserved.
//

#import "JpDataStoreUtil.h"
#import "NSString+Jp.h"
#import "JpLogUtil.h"

@implementation JpDataStoreUtil

+ (void)saveDataToUserDefaultsForKey:(NSString*)key value:(NSObject*)value
{
    // Save the data
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
    [JpLogUtil log:@"Saving to NSUserDefault is " append:key  append:@":" append:value];
}

+ (NSString*)getValueFromUserDefaultByKey: (NSString*)key
{
    if ([key isEmpty]) {
        return nil;
    } else {
        NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *loadstring = [userDefaults objectForKey:key];
        return loadstring;
    }
}



@end
