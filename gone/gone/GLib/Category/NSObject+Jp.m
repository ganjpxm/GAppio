//
//  NSObject+Jp.m
//  JpSample
//
//  Created by Johnny on 22/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "NSObject+Jp.h"

@implementation NSObject (Jp)


-(BOOL) isNotEmpty
{
    return !(self == nil || [self isKindOfClass:[NSNull class]] || ([self respondsToSelector:@selector(length)] && [(NSData *)self length] == 0) || ([self respondsToSelector:@selector(count)] && [(NSArray *)self count] == 0));
};
@end
