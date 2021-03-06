//
//  ObsdBookingVehicleDetailVC.h
//  obsd
//
//  Created by ganjianping on 13/4/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "JpVC.h"
#import <CoreLocation/CoreLocation.h>
#import "JBSignatureController.h"

@interface ObsUpcomingBookingDetailVC : JpVC<CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,JBSignatureControllerDelegate>
{
    NSMutableArray *drivers;
    NSMutableArray *vehicleInfos;
    NSString *vehicleInfoStr;
   
    
    UIView *driverSelView;
    UIView *driverView;
    UIPickerView *driverPV;
    UIToolbar *driverPickerToolbar;
}
- (id)init:(NSString *)from data:(NSDictionary *)bookingVehicleDetail;

@end
