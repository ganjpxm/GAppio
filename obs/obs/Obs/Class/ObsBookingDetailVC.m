//
//  ObsdBookingVehicleDetailVC.m
//  obsd
//
//  Created by ganjianping on 13/4/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "ObsBookingDetailVC.h"
#import "JpUiUtil.h"
#import "JpDateUtil.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>


@interface ObsBookingDetailVC ()

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSDictionary *bookingVehicleDetail;

@end

@implementation ObsBookingDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (id)init:(NSString *)from data:(NSDictionary *)bookingVehicleDetail
{
    self = [super init];
    if (self) {
        _from = from;
        _bookingVehicleDetail = bookingVehicleDetail;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set screen name.
    self.screenName = SCREEN_BOOKING_DETAIL;
    
    // Do any additional setup after loading the view.
    [self setTitle:[_bookingVehicleDetail objectForKey:COLUMN_BOOKING_NUMBER]];
    [self.view setBackgroundColor:LIGHT_GRAY_COLOR];
    
    
    NSInteger startHeightOffset = [JpUiUtil getStartHeightOffset];
    UIScrollView  *scrollView = [[UIScrollView alloc] init];
    
    scrollView.frame = CGRectMake(0, 5, [JpUiUtil getScreenWidth], [JpUiUtil getScreenHeight]+startHeightOffset);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    
    long y = 0;
    NSString *service = [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_SERVICE];
    unsigned long long pickupDatetimeLong = [[self.bookingVehicleDetail objectForKey:COLUMN_PICKUP_DATE_TIME] longLongValue];
    NSString *pickupDatetime = [JpDateUtil getDateTimeStrByMilliSecond:pickupDatetimeLong dateFormate:@"EEE, dd MMM yyyy, HH:mm"];
    
    UIView *view1 = [self createBoxViewWithStartY:y firstText:service secondText:pickupDatetime tag:0];
    [scrollView addSubview:view1];
    
    NSString *pickupAddress = [self.bookingVehicleDetail objectForKey:COLUMN_PICKUP_ADDRESS];
    
    NSString *serviceCd = [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_SERVICE_CD];
    NSString *flightNumber = [self.bookingVehicleDetail objectForKey:COLUMN_FLIGHT_NUMBER];
    if ([serviceCd length]>0 && [VALUE_BOOKING_SERVICE_CD_ARRIVAL isEqualToString:serviceCd]) {
        pickupAddress = [NSString stringWithFormat:@"%@ %@", flightNumber, pickupAddress];
    }
    y += view1.frame.size.height + 5;
    UIView *view2 = [self createBoxViewWithStartY:y firstText:@"From" secondText:pickupAddress tag:MAP_DIRECTION];
    [scrollView addSubview:view2];
    
    NSString *destination = [self.bookingVehicleDetail objectForKey:COLUMN_DESTINATION];
    if ([serviceCd length]>0 && [VALUE_BOOKING_SERVICE_CD_DEPARTURE isEqualToString:serviceCd]) {
        pickupAddress = [NSString stringWithFormat:@"%@ %@", flightNumber, destination];
    }
    y += view2.frame.size.height + 5;
    UIView *view3 = [self createBoxViewWithStartY:y firstText:@"To" secondText:destination tag:MAP_ROUTE];
    [scrollView addSubview:view3];
    
    NSString *leadPassenger = [NSString stringWithFormat:@"%@ %@ %@ ",[self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_GENDER],[self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_FIRST_NAME], [self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_LAST_NAME]];
    NSString *numberOfPassenger =  [self.bookingVehicleDetail objectForKey:COLUMN_NUMBER_OF_PASSENGER];
    if ([numberOfPassenger length]>0 && ![numberOfPassenger isEqualToString:@"<null>"]) {
        leadPassenger = [NSString stringWithFormat:@"%@ \n%@ passengers", leadPassenger, numberOfPassenger];
    }
    
    y += view3.frame.size.height + 5;
    UIView *view4 = [self createBoxViewWithStartY:y firstText:@"Lead Passenger" secondText:leadPassenger tag:CALL_LEAD_PASSENGER];
    [scrollView addSubview:view4];
    
    NSString *bookByPerson = [NSString stringWithFormat:@"%@ %@ %@", [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_USER_GENDER], [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_USER_FIRST_NAME],[self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_USER_LAST_NAME]];
    
   
    
    y += view4.frame.size.height + 5;
    UIView *view5 = [self createBoxViewWithStartY:y firstText:@"Book by" secondText:bookByPerson tag:CALL_BOOK_BY_USER];
    [scrollView addSubview:view5];
    
    NSString *assigner = @"";
    if ([assigner length]<1) {
        assigner = [self.bookingVehicleDetail objectForKey:COLUMN_OPERATOR_NAME];
    }
    NSString *orgName = [self.bookingVehicleDetail objectForKey:COLUMN_ORG_NAME];
    if ([orgName length]>0 && ![orgName isEqualToString:@"<null>"]) {
        assigner = [NSString stringWithFormat:@"%@ \nfrom %@", assigner, orgName];
    }
    y += view5.frame.size.height + 5;
//    UIView *view6 = [self createBoxViewWithStartY:y firstText:@"Assign by" secondText:assigner tag:CALL_ASSIGNER];
//    [scrollView addSubview:view6];
//    
//    y += view6.frame.size.height + 5;
    NSString *remark = [self.bookingVehicleDetail objectForKey:COLUMN_REMARK];
    if ([remark length]>1 && ![remark isEqualToString:@"<null>"]) {
        UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, [JpUiUtil getScreenWidth]-16, 30)];
        remarkLabel.text = remark;
        remarkLabel.numberOfLines = 0;
        remarkLabel.backgroundColor = [UIColor clearColor];
        remarkLabel.textColor = [UIColor blackColor];
        remarkLabel.textAlignment = NSTextAlignmentLeft;
        remarkLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        remarkLabel.lineBreakMode = YES;
        remarkLabel.textAlignment = NSTextAlignmentLeft;
        [remarkLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [remarkLabel sizeToFit];
        long remarkLabelHeight = remarkLabel.frame.size.height;

        UIView *remarkView = [[UIView alloc] initWithFrame:CGRectMake(8, y, [JpUiUtil getScreenWidth]-16, remarkLabelHeight+20)];
        [remarkView setBackgroundColor:[UIColor whiteColor]];
        [remarkView addSubview:remarkLabel];
        [scrollView addSubview:remarkView];
        y += remarkView.frame.size.height + 5;
    }
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude zoom:12];
//    GMSMapView *gmsMapView = [GMSMapView mapWithFrame:CGRectMake(10, y, 300, 150) camera:camera];
//    gmsMapView.myLocationEnabled = YES;
    
    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
//    marker.map = gmsMapView;
    
//    y += gmsMapView.frame.size.height + 5;
    
//    [scrollView addSubview:gmsMapView];
//    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, y)];
   
}

- (UIView *)createBoxViewWithStartY:(long)y firstText:(NSString*)firstText secondText:(NSString*)secondText tag:(NSInteger)tag
{
    long width = [JpUiUtil getScreenWidth]-26;
    if (tag>0) {
        width = [JpUiUtil getScreenWidth]-66;
    }
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, width, 30)];
    firstLabel.text = firstText;
    firstLabel.numberOfLines = 0;
    firstLabel.backgroundColor = [UIColor clearColor];
    firstLabel.textColor = [UIColor grayColor];
    firstLabel.textAlignment = NSTextAlignmentLeft;
    firstLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    firstLabel.lineBreakMode = YES;
    firstLabel.textAlignment = NSTextAlignmentLeft;
    [firstLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [firstLabel sizeToFit];
    long firstLabelHeight = firstLabel.frame.size.height;

    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, firstLabelHeight+10, width, 30)];
    secondLabel.text = secondText;
    secondLabel.numberOfLines = 0;
    secondLabel.backgroundColor = [UIColor clearColor];
    secondLabel.textColor = [UIColor blackColor];
    secondLabel.textAlignment = NSTextAlignmentLeft;
    secondLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    secondLabel.lineBreakMode = YES;
    secondLabel.textAlignment = NSTextAlignmentLeft;
    [secondLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [secondLabel sizeToFit];
    long secondLabelHeight = secondLabel.frame.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, y, [JpUiUtil getScreenWidth]-16, firstLabelHeight + secondLabelHeight + 20)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:firstLabel];
    [view addSubview:secondLabel];
    
    if (tag>0) {
        width = [JpUiUtil getScreenWidth] - 66;
        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        callBtn.frame = CGRectMake(width+5, (firstLabelHeight + secondLabelHeight - 40)/2 + 10 , 40, 40);
        [callBtn setTag:tag];
        if (tag==MAP_DIRECTION) {
            [callBtn setImage:[UIImage imageNamed:@"icon_direction_blue"] forState:UIControlStateNormal];
            [callBtn addTarget:self action:@selector(onOpenMapBtn:) forControlEvents:UIControlEventTouchUpInside];
        } else if (tag==MAP_ROUTE) {
            [callBtn setImage:[UIImage imageNamed:@"icon_route_red"] forState:UIControlStateNormal];
            [callBtn addTarget:self action:@selector(onOpenMapBtn:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [callBtn setImage:[UIImage imageNamed:@"icon_call_green"] forState:UIControlStateNormal];
            [callBtn addTarget:self action:@selector(onCallBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [view addSubview:callBtn];
    }
    
    return view;
}

- (IBAction)onOpenMapBtn:(id)sender {
    NSInteger tag = (NSInteger)[sender tag];
    NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    if ([[UIApplication sharedApplication] canOpenURL:testURL]) {
        NSString *pickupAddress = [self.bookingVehicleDetail objectForKey:COLUMN_PICKUP_ADDRESS];
        NSString *destinationAddress = [self.bookingVehicleDetail objectForKey:COLUMN_DESTINATION];
        pickupAddress = [pickupAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        destinationAddress = [destinationAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];

        //Google Maps URL Scheme
        
        NSString *directionsRequest = [NSString stringWithFormat:@"comgooglemaps-x-callback://?daddr=%@&zoom=17&x-success=obsd://page/one?token=1&domain=org.ganjp&x-source=Driver+App&directionsmode=driving", pickupAddress];//driving
        if (tag==MAP_ROUTE) {
            directionsRequest = [NSString stringWithFormat:@"comgooglemaps-x-callback://?saddr=%@&daddr=%@&x-success=obsd://page/one?token=1&domain=org.ganjp&x-source=Driver+App&directionsmode=driving", pickupAddress, destinationAddress];
        }
        
        NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
        [[UIApplication sharedApplication] openURL:directionsURL];
    } else {
        NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
    }
}

- (IBAction)onCallBtn:(id)sender {
    NSInteger tag = (NSInteger)[sender tag];
    NSString *title = @"";
    NSString *mobileNumber = @"";
    if (tag==CALL_LEAD_PASSENGER) {
        title =  @"Call Lead Passenger";
        mobileNumber = [self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_MOBILE_NUMBER];
    } else if (tag==CALL_BOOK_BY_USER) {
        title =  @"Call Booking User";
        mobileNumber = [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_USER_MOBILE_NUMBER];
    } else if (tag==CALL_ASSIGNER) {
        title =  @"Call Assigner";
        mobileNumber = [self.bookingVehicleDetail objectForKey:@""];
    }
    UIAlertView *alertCallHotline = [[UIAlertView alloc]initWithTitle:title  message:mobileNumber delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call",nil];
    alertCallHotline.tag = CALL_LEAD_PASSENGER;
    [alertCallHotline show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CALL_LEAD_PASSENGER || alertView.tag == CALL_BOOK_BY_USER || alertView.tag == CALL_LEAD_PASSENGER) {
        if (buttonIndex == 1)
        {
            NSString *mobileNumber = @"";
            if (alertView.tag==CALL_LEAD_PASSENGER) {
                mobileNumber = [self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_MOBILE_NUMBER];
            } else if (alertView.tag==CALL_BOOK_BY_USER) {
                mobileNumber = [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_USER_MOBILE_NUMBER];
            } else if (alertView.tag==CALL_ASSIGNER) {
                mobileNumber = [self.bookingVehicleDetail objectForKey:@""];
            }
            NSString *tel = [@"tel:" stringByAppendingString:mobileNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
        }
    }
}


@end
