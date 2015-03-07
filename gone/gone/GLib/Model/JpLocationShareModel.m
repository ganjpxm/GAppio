//
//  LocationShareModel.m
//  obs
//
//  Created by ganjianping on 7/3/15.
//  Copyright (c) 2015 lt. All rights reserved.
//

#import "JpLocationShareModel.h"

@implementation JpLocationShareModel

//Class method to make sure the share model is synch across the app
+ (id)sharedModel
{
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    return sharedMyModel;
}


@end
