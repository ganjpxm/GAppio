//
//  AppDelegate.h
//  obs
//
//  Created by ganjianping on 4/2/15.
//  Copyright (c) 2015 lt. All rights reserved.
//
#import "JpLocationShareModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) JpLocationShareModel * shareModel;

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

@property (nonatomic) NSString *locationName;

@end

