//
//  DateUtil.m
//  JOne
//
//  Created by Johnny on 29/10/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (NSInteger) getCurMilliseconded
{
   return ([[NSDate date] timeIntervalSince1970] * 1000);
}

+ (NSString *) getDateTimeStrByMilliSecond:(unsigned long long)aMillisecond
{
    long millisecond = (long)aMillisecond;
    long second = millisecond/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *) getDateStrByMilliSecond:(unsigned long long)aMillisecond
{
    long millisecond = (long)aMillisecond;
    long second = millisecond/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return [dateFormatter stringFromDate:date];
}

@end
