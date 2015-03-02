//
//  JpUtil.m
//  JOne
//
//  Created by Johnny on 26/10/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import "ObsData.h"
#import "JpSystemUtil.h"


static NSUserDefaults *userDefaults;

@implementation ObsData

//Plist
+ (NSMutableDictionary *)getObsdDic
{
    NSString *obscPlistPath = [[NSBundle mainBundle] pathForResource:KEY_OBS ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:obscPlistPath];
    return dic;
}

@end
