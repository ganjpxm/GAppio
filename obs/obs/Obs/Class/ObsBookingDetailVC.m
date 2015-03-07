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
#import "JpConst.h"
#import "JpUtil.h"
#import "NSString+Jp.h"

@interface ObsBookingDetailVC ()

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSDictionary *bookingVehicleDetail;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CLLocation *currentLocation;

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
    [self.view setBackgroundColor:COLOR_GRAY_LIGHT_PRIMARY];
    
    
    NSInteger startHeightOffset = [JpUiUtil getStartHeightOffset];
    UIScrollView  *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 5, [JpUiUtil getScreenWidth], [JpUiUtil getScreenHeight]+startHeightOffset);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    
    long y = 2;
    //pickup time
    NSString *service = [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_SERVICE];
    unsigned long long pickupDatetimeLong = [[self.bookingVehicleDetail objectForKey:COLUMN_PICKUP_DATE_TIME] longLongValue];
    NSString *pickupDatetime = [JpDateUtil getDateTimeStrByMilliSecond:pickupDatetimeLong dateFormate:@"EEE, dd MMM yyyy, HH:mm a"];
    UIView *view1 = [self createBoxViewWithStartY:y firstText:service secondText:pickupDatetime tag:0];
    [scrollView addSubview:view1];
    
    //FROM
    NSString *pickupAddress = [self.bookingVehicleDetail objectForKey:COLUMN_PICKUP_ADDRESS];
    NSString *serviceCd = [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_SERVICE_CD];
    NSString *flightNumber = [self.bookingVehicleDetail objectForKey:COLUMN_FLIGHT_NUMBER];
    if ([serviceCd length]>0 && [VALUE_BOOKING_SERVICE_CD_ARRIVAL isEqualToString:serviceCd] && [flightNumber length]>1 &&
        ![@"<null>" isEqualToString:flightNumber]) {
        pickupAddress = [NSString stringWithFormat:@"%@ %@ ", flightNumber, pickupAddress];
    }
    y += view1.frame.size.height + 5;
    UIView *view2 = [self createBoxViewWithStartY:y firstText:@"From" secondText:pickupAddress tag:MAP_DIRECTION];
    [scrollView addSubview:view2];
    y += view2.frame.size.height + 5;
    
    NSString *stop1Address = [self.bookingVehicleDetail objectForKey:COLUMN_STOP1_ADDRESS];
    if (stop1Address && [stop1Address length]>8) {
        UIView *view2s1 = [self createBoxViewWithStartY:y firstText:@"Stop 1 Address" secondText:stop1Address tag:MAP_ROUTE_STOP1];
        [scrollView addSubview:view2s1];
         y += view2s1.frame.size.height + 5;
    }
    NSString *stop2Address = [self.bookingVehicleDetail objectForKey:COLUMN_STOP2_ADDRESS];
    if (stop2Address && [stop2Address length]>8) {
        UIView *view2s2 = [self createBoxViewWithStartY:y firstText:@"Stop 2 Address" secondText:stop2Address tag:MAP_ROUTE_STOP2];
        [scrollView addSubview:view2s2];
        y += view2s2.frame.size.height + 5;
    }
    
    //TO
    NSString *destination = [self.bookingVehicleDetail objectForKey:COLUMN_DESTINATION];
    if ([serviceCd length]>0 && [VALUE_BOOKING_SERVICE_CD_DEPARTURE isEqualToString:serviceCd] && [flightNumber length]>1 &&
       ![@"<null>" isEqualToString:flightNumber]) {
        destination = [NSString stringWithFormat:@"%@ %@", flightNumber, destination];
    }
    UIView *view3 = [self createBoxViewWithStartY:y firstText:@"To" secondText:destination tag:MAP_ROUTE];
    [scrollView addSubview:view3];
    
    //Lead Passenger
    NSString *firstName = [self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_FIRST_NAME];
    NSString *lastName = [self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_LAST_NAME];
    NSString *leadPassenger = [self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_GENDER];
    if (firstName && [firstName length]>1) {
        leadPassenger = [NSString stringWithFormat:@"%@ %@ ", leadPassenger, firstName];
    }
    if (lastName && [lastName length]>1) {
        leadPassenger = [NSString stringWithFormat:@"%@ %@ ", leadPassenger, lastName];
    }
    y += view3.frame.size.height + 5;
    UIView *view4 = [self createBoxViewWithStartY:y firstText:@"Lead Passenger" secondText:leadPassenger tag:CALL_LEAD_PASSENGER];
    [scrollView addSubview:view4];
    
    //Book by
    NSString *bookByPerson = [NSString stringWithFormat:@"%@ %@ %@", [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_USER_GENDER], [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_USER_FIRST_NAME],[self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_USER_LAST_NAME]];
    y += view4.frame.size.height + 5;
    UIView *view5 = [self createBoxViewWithStartY:y firstText:@"Book by" secondText:bookByPerson tag:CALL_BOOK_BY_USER];
    [scrollView addSubview:view5];
    y += view5.frame.size.height + 5;
    
    //Vehicle
    NSString *vehicle = [self.bookingVehicleDetail objectForKey:COLUMN_VEHICLE];
    NSString *numberOfPassenger =  [self.bookingVehicleDetail objectForKey:COLUMN_NUMBER_OF_PASSENGER];
    if ([numberOfPassenger length]>0 && ![numberOfPassenger isEqualToString:@"<null>"]) {
        vehicle = [NSString stringWithFormat:@"     %@ - %@ passenger(s)", vehicle, numberOfPassenger];
    }
    UILabel *vehicleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 16, [JpUiUtil getScreenWidth]-32, 50)];
    vehicleLabel.text = vehicle;
    vehicleLabel.numberOfLines = 0;
    vehicleLabel.backgroundColor = [UIColor clearColor];
    vehicleLabel.textColor = [UIColor blackColor];
    vehicleLabel.textAlignment = NSTextAlignmentLeft;
    vehicleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    vehicleLabel.lineBreakMode = YES;
    vehicleLabel.textAlignment = NSTextAlignmentLeft;
    [vehicleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [vehicleLabel sizeToFit];
    long vehicleLabelHeight = vehicleLabel.frame.size.height;
    UIView *vehicleView = [[UIView alloc] initWithFrame:CGRectMake(8, y, [JpUiUtil getScreenWidth]-16, vehicleLabelHeight+32)];
    [vehicleView setBackgroundColor:[UIColor whiteColor]];
    UIImage *vehicleImage = [UIImage imageNamed: @"icon_vehicle_black"];
    UIImageView *vehicleIV = [[UIImageView alloc] initWithImage: vehicleImage];
    [vehicleIV setFrame:CGRectMake(8, 18, 18, 18)];
    [vehicleView addSubview:vehicleLabel];
    [vehicleView addSubview:vehicleIV];
     [scrollView addSubview:vehicleView];
     y += vehicleView.frame.size.height + 5;
    
    //Remark
    NSString *remark = [self.bookingVehicleDetail objectForKey:COLUMN_REMARK];
    if ([remark length]>1 && ![remark isEqualToString:@"<null>"]) {
        UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, [JpUiUtil getScreenWidth]-32, 30)];
        remarkLabel.text = [NSString stringWithFormat:@"     %@", remark];
        remarkLabel.numberOfLines = 0;
        remarkLabel.backgroundColor = [UIColor clearColor];
        remarkLabel.textColor = [UIColor blackColor];
        remarkLabel.textAlignment = NSTextAlignmentLeft;
        remarkLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        remarkLabel.lineBreakMode = YES;
        remarkLabel.textAlignment = NSTextAlignmentLeft;
        [remarkLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [remarkLabel sizeToFit];
        long remarkLabelHeight = remarkLabel.frame.size.height;

        UIView *remarkView = [[UIView alloc] initWithFrame:CGRectMake(8, y, [JpUiUtil getScreenWidth]-16, remarkLabelHeight+16)];
        [remarkView setBackgroundColor:[UIColor whiteColor]];
        [remarkView addSubview:remarkLabel];
        [scrollView addSubview:remarkView];
        y += remarkView.frame.size.height + 5;
        
        UIImage *commentImage = [UIImage imageNamed: @"icon_comment_red"];
        UIImageView *commentIV = [[UIImageView alloc] initWithImage: commentImage];
        [commentIV setFrame:CGRectMake(8, 10, 18, 15)];
        [remarkView addSubview:commentIV];
    }
    //        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"   %@", remark]];
    //        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    //        textAttachment.image = [UIImage imageNamed:@"icon_comment_red"];
    //        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    //        [attributedString replaceCharactersInRange:NSMakeRange(0, 2) withAttributedString:attrStringWithImage];
    //        remarkLabel.attributedText = attributedString;
    //        float width = [JpUiUtil getScreenWidth]-100;
    //        long remarkLabelHeight = [JpUtil getRealHeight:attributedString width:width];
    
    @try {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    
        float latitude = self.locationManager.location.coordinate.latitude;
        float longitude = self.locationManager.location.coordinate.longitude;
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:11];
        
        GMSMapView *gmsMapView = [GMSMapView mapWithFrame:CGRectMake(10, y, [JpUiUtil getScreenWidth]-16, [JpUiUtil getScreenHeight]-100) camera:camera];
        gmsMapView.myLocationEnabled = YES;
    
        [scrollView addSubview:gmsMapView];
        y += gmsMapView.frame.size.height + 5;
        
        GMSMutablePath *path = [GMSMutablePath path];
        [self getGMSMarker:[self.bookingVehicleDetail objectForKey:COLUMN_PICKUP_ADDRESS] title:@"Pick-up Address" imageName:@"icon_location_1" path:path].map = gmsMapView;
        NSString *destinationImageName = @"icon_location_2";
        if (stop1Address && [stop1Address length]>8) {
            [self getGMSMarker:stop1Address title:@"Stop 1 Address" imageName:@"icon_location_2" path:path].map = gmsMapView;
            if (stop2Address && [stop2Address length]>8) {
                destinationImageName = @"icon_location_4";
            } else {
                destinationImageName = @"icon_location_3";
            }
        }
        if (stop2Address && [stop2Address length]>8) {
            [self getGMSMarker:stop2Address title:@"Stop 2 Address" imageName:@"icon_location_3" path:path].map = gmsMapView;
        }
        [self getGMSMarker:[self.bookingVehicleDetail objectForKey:COLUMN_DESTINATION] title:@"Destination" imageName:destinationImageName path:path].map = gmsMapView;
        
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeColor = COLOR_BLACK_JP;
        polyline.strokeWidth = 5.f;
        polyline.map = gmsMapView;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception:%@",exception);
    }
    @finally {
        //Display Alternative
    }
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, y+8)];
    [[self.navigationController navigationBar] setTintColor:[UIColor whiteColor]];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [backButton setTitle:@" Back" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (UIView *)createBoxViewWithStartY:(long)y firstText:(NSString*)firstText secondText:(NSString*)secondText tag:(NSInteger)tag
{
    long width = [JpUiUtil getScreenWidth]-26;
    if (tag>0) {
        width = [JpUiUtil getScreenWidth]-66;
    }
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, width, 30)];
    firstLabel.text = firstText;
    firstLabel.numberOfLines = 0;
    firstLabel.backgroundColor = [UIColor clearColor];
    firstLabel.textColor = [UIColor grayColor];
    firstLabel.textAlignment = NSTextAlignmentLeft;
    firstLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    firstLabel.lineBreakMode = YES;
    firstLabel.textAlignment = NSTextAlignmentLeft;
    [firstLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [firstLabel sizeToFit];
    long firstLabelHeight = firstLabel.frame.size.height;

    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, firstLabelHeight+8, width-8, 30)];
    
    long secondLabelHeight;
    if ([secondText containsString:@"<b>"]) {
        NSMutableAttributedString *attributedText = [JpUtil getHtmlAttributedString:secondText];
        secondLabel.attributedText = attributedText;
        secondLabelHeight = [JpUtil getRealHeight:attributedText width:width];
    } else {
        secondLabel.text = secondText;
        
        secondLabel.numberOfLines = 0;
        secondLabel.backgroundColor = [UIColor clearColor];
        secondLabel.textColor = [UIColor blackColor];
        secondLabel.textAlignment = NSTextAlignmentLeft;
        secondLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        secondLabel.lineBreakMode = YES;
        secondLabel.textAlignment = NSTextAlignmentLeft;
        [secondLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [secondLabel sizeToFit];
        secondLabelHeight = secondLabel.frame.size.height;
    }
    
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
        } else if (tag==MAP_ROUTE || tag==MAP_ROUTE_STOP1 || tag==MAP_ROUTE_STOP2) {
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
        NSString *stop1Address = [self.bookingVehicleDetail objectForKey:COLUMN_STOP1_ADDRESS];
        NSString *stop2Address = [self.bookingVehicleDetail objectForKey:COLUMN_STOP2_ADDRESS];
        NSString *destinationAddress = [self.bookingVehicleDetail objectForKey:COLUMN_DESTINATION];
        
        pickupAddress = [pickupAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        stop1Address = [stop1Address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        stop2Address = [stop2Address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        destinationAddress = [destinationAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];

        //Google Maps URL Scheme
        
        NSString *directionsRequest = [NSString stringWithFormat:@"comgooglemaps-x-callback://?daddr=%@&zoom=17&x-success=obsd://page/one?token=1&domain=org.ganjp&x-source=Driver+App&directionsmode=driving", pickupAddress];//driving
        
        if (tag==MAP_ROUTE_STOP1) {
            directionsRequest = [NSString stringWithFormat:@"comgooglemaps-x-callback://?saddr=%@&daddr=%@&x-success=obsd://page/one?token=1&domain=org.ganjp&x-source=Driver+App&directionsmode=driving", pickupAddress, stop1Address];
        } else if (tag==MAP_ROUTE_STOP2) {
            directionsRequest = [NSString stringWithFormat:@"comgooglemaps-x-callback://?saddr=%@&daddr=%@&x-success=obsd://page/one?token=1&domain=org.ganjp&x-source=Driver+App&directionsmode=driving", stop1Address, stop2Address];
        } else if (tag==MAP_ROUTE) {
            if (stop1Address && [stop1Address length]>8) {
                if (stop2Address && [stop2Address length]>8) {
                    pickupAddress = stop2Address;
                } else {
                    pickupAddress = stop1Address;
                }
            }
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

- (IBAction)onClickBackBtn:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    CLLocation *location = [locations lastObject];
//    
//    // Output the time the location update was received
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateStyle = NSDateFormatterNoStyle;
//    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
//    NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
//    
//    // Create a string from the CLLocation
//    NSString *latLonString = [self stringFromCoordinate:location.coordinate];
//    
//    self.currentLocation = [locations objectAtIndex:0];
//    [self.locationManager stopUpdatingLocation];
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
//    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         if (!(error))
//         {
//             CLPlacemark *placemark = [placemarks objectAtIndex:0];
//             NSLog(@"\nCurrent Location Detected\n");
//             NSLog(@"placemark %@",placemark);
//             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//             NSString *Address = [[NSString alloc]initWithString:locatedAt];
//             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
//             NSString *Country = [[NSString alloc]initWithString:placemark.country];
//             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
//             NSLog(@"%@",CountryArea);
//         }
//         else
//         {
//             NSLog(@"Geocode failed with error %@", error);
//             NSLog(@"\nCurrent Location Not Detected\n");
//         }
//     }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

- (NSString *)stringFromCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [NSString stringWithFormat:@"%f %f", coordinate.latitude, coordinate.longitude];
}

-(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

- (GMSMarker *)getGMSMarker:(NSString*)address title:(NSString*)title imageName:(NSString*)imageName path:(GMSMutablePath *)path
{
    if (address && [address containsString:@"("]) {
        NSRange range = NSMakeRange(0, [address indexOf:@"("]);
        address = [address substringWithRange:range];
    }
    
    CLLocationCoordinate2D addressLocation = [self getLocationFromAddressString:address];
    float lat = addressLocation.latitude;
    float lng = addressLocation.longitude;
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat, lng);
    marker.title = title;
    marker.snippet = address;
    if (imageName && [imageName length]>1) {
        marker.icon = [UIImage imageNamed:imageName];
    }
    if (path) {
        [path addLatitude:lat longitude:lng];
    }
    return marker;
}

@end
