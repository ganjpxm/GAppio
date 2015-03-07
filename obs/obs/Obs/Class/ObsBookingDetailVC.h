//
//  ObsdBookingVehicleDetailVC.h
//  obsd
//
//  Created by ganjianping on 13/4/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "JpVC.h"
#import <CoreLocation/CoreLocation.h>

@interface ObsBookingDetailVC : JpVC<CLLocationManagerDelegate>

- (id)init:(NSString *)from data:(NSDictionary *)bookingVehicleDetail;

@end
