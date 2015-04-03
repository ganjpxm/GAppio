//
//  DateUtil.h
//  JOne
//
//  Created by Johnny on 29/10/13.
//  Copyright (c) 2013 ganjp. All rights reserved.

@interface JpDateUtil : NSObject

+ (NSInteger)getCurDateTimeMillisecond;
+ (NSInteger)getMilliSecondFromDateString:(NSString *)dateStr;
+ (NSInteger)getMilliSecondFromDateTimeString:(NSString *)dateTimeStr;

+ (NSString *)getDateTimeStrByMilliSecond:(unsigned long long)aMillisecond;
+ (NSString *)getDateStrByMilliSecond:(unsigned long long)aMillisecond;
+ (NSString *) getDateTimeStrByMilliSecond:(unsigned long long)aMillisecond dateFormate:(NSString *)dateFormate;

+ (NSString *)getCurrentDateStr;
+ (NSString *)getCurrentTimeStr;
+ (NSString *)getCurrentYearStr;
+ (NSString *)getCurrentDateTimeWithAmPmStr;
+ (NSString *)getTomorrowDateStr;
+ (NSString *)getDateStrWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

+ (NSDate *)getDateFromString:(NSString *)dateStr;
+ (NSDate *)getDateTimeFromString:(NSString *)dateStr;


@end
