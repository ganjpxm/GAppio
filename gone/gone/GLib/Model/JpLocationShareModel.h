//
//  LocationShareModel.h
//  obs
//
//  Created by ganjianping on 7/3/15.
//  Copyright (c) 2015 lt. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface JpLocationShareModel : NSObject

@property (nonatomic) CLLocationManager * anotherLocationManager;

@property (nonatomic) NSMutableDictionary *myLocationDictInPlist;
@property (nonatomic) NSMutableArray *myLocationArrayInPlist;

@property (nonatomic) BOOL afterResume;

+(id)sharedModel;

@end
