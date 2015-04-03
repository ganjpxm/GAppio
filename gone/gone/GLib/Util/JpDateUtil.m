//
//  DateUtil.m
//  JOne
//
//  Created by Johnny on 29/10/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

#import "JpDateUtil.h"

@implementation JpDateUtil

+ (NSInteger) getCurDateTimeMillisecond
{
   return ([[NSDate date] timeIntervalSince1970] * 1000);
}

+ (NSInteger)getMilliSecondFromDateString:(NSString *)dateStr
{
    NSDate *date = [self getDateFromString:dateStr];
    return ([date timeIntervalSince1970] * 1000);
}

+ (NSInteger)getMilliSecondFromDateTimeString:(NSString *)dateTimeStr
{
    NSDate *date = [self getDateTimeFromString:dateTimeStr];
    return ([date timeIntervalSince1970] * 1000);
}

+ (NSString *) getDateTimeStrByMilliSecond:(unsigned long long)aMillisecond
{
    unsigned long long millisecond = (unsigned long long)aMillisecond;
    unsigned long long second = millisecond/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

//EEE, dd MMM yyyy,
+ (NSString *) getDateTimeStrByMilliSecond:(unsigned long long)aMillisecond dateFormate:(NSString *)dateFormate
{
    unsigned long long millisecond = (unsigned long long)aMillisecond;
    unsigned long long second = millisecond/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormate];
    return [dateFormatter stringFromDate:date];
}


+ (NSString *) getDateStrByMilliSecond:(unsigned long long)aMillisecond
{
    unsigned long long millisecond = (unsigned long long)aMillisecond;
    unsigned long long second = millisecond/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *formatDate = [dateFormatter stringFromDate:date];
    NSLog(@"%@", formatDate);
    return formatDate;
}

+ (NSString *)getCurrentDateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)getTomorrowDateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
    return [dateFormatter stringFromDate:tomorrow];
}
+ (NSString *)getCurrentTimeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:[NSDate date]];
}
+ (NSString *)getCurrentYearStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    return [dateFormatter stringFromDate:[NSDate date]];
}
+ (NSString *)getCurrentDateTimeWithAmPmStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm a"];
    return [dateFormatter stringFromDate:[NSDate date]];
}
+ (NSString *)getDateStrWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)getDateFromString:(NSString *)dateStr
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:(@"dd/MM/yyyy")];
    return [formate dateFromString:dateStr];
}

+ (NSDate *)getDateTimeFromString:(NSString *)dateStr
{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:(@"dd/MM/yyyy HH:mm:ss")];
    return [formate dateFromString:dateStr];
}



@end
