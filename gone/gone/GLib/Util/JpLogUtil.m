//
//  JpLogUtil.m
//  JpSample
//
//  Created by Johnny on 27/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "JpLogUtil.h"

@implementation JpLogUtil

+ (void)log:(NSString *)message
{
    NSLog(@"%@", message); //%@, %d, %i, %u , %f , %x, %X, %o, %zu, %p, %e , %g, %s, %.*s, %c , %C, %lld, %llu, %Lf
}


+ (void)log:(NSString *)message append:(NSObject *)obj
{
    NSLog(@"%@ %@", message, obj);
}

+ (void)log:(NSString *)message append:(NSObject *)obj1 append:(NSObject *)obj2
{
    NSLog(@"%@ %@ %@", message, obj1, obj2);
}

+ (void)log:(NSString *)message append:(NSObject *)obj1 append:(NSObject *)obj2 append:(NSObject *)obj3
{
    NSLog(@"%@ %@ %@ %@", message, obj1, obj2, obj3);
}

@end
