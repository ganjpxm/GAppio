//
//  JpUtil.m
//  JOne
//
//  Created by Johnny on 26/10/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import "ObsdData.h"
#import "JpSystemUtil.h"


static NSUserDefaults *userDefaults;

@implementation ObsdData

//Plist
+ (NSMutableDictionary *)getObsdDic
{
    NSString *obscPlistPath = [[NSBundle mainBundle] pathForResource:KEY_OBSD ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:obscPlistPath];
    return dic;
}

@end
