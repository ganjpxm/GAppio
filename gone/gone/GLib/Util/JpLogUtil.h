//
//  JpLogUtil.h
//  JpSample
//
//  Created by Johnny on 27/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

@interface JpLogUtil : NSObject

+ (void)log:(NSString *)message;
+ (void)log:(NSString *)message append:(NSObject *)obj;
+ (void)log:(NSString *)message append:(NSObject *)obj1 append:(NSObject *)obj2;
+ (void)log:(NSString *)message append:(NSObject *)obj1 append:(NSObject *)obj2 append:(NSObject *)obj3;

@end
