//
//  ObsdBookingVehicleDetailVC.m
//  obsd
//
//  Created by ganjianping on 13/4/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "ObsHistoryBookingDetailVC.h"
#import "JpUiUtil.h"
#import "JpDateUtil.h"
#import <GoogleMaps/GoogleMaps.h>
#import "JpConst.h"
#import "JpUtil.h"
#import "NSString+Jp.h"
#import "JpDataUtil.h"
#import "JpFXBlurView.h"
#import "ObsDBManager.h"
#import "JpSystemUtil.h"
#import "ObsDBManager.h"
#import "ObsWebAPIClient.h"
#import "UIAlertView+AFNetworking.h"
#import "JBSignatureController.h"
#import "JpFileUtil.h"
#import "UIImage+Rotate.h"


@interface ObsHistoryBookingDetailVC ()

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSDictionary *bookingVehicleDetail;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) NSString *pickupAddress;
@property (strong, nonatomic) NSString *destination;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) UIButton *bookingCompleteBtn;

@property (nonatomic, strong) JpFXBlurView           *mask;
@property (nonatomic, strong) ObsBookingCompleteVC   *bookingCompleteVC;

@property (strong, nonatomic) UIScrollView  *scrollView;

@property (strong, nonatomic) UIButton *signatureImageBtn;

@end

@implementation ObsHistoryBookingDetailVC

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
    self.screenName = SCREEN_BOOKING_HISTORY_DETAIL;
    
    _bookingCompleteVC = [[ObsBookingCompleteVC alloc] init];
    [_bookingCompleteVC setDelegate:self];
    
    // Do any additional setup after loading the view.
    [self setTitle:[_bookingVehicleDetail objectForKey:COLUMN_BOOKING_NUMBER]];
    [self.view setBackgroundColor:COLOR_GRAY_LIGHT_PRIMARY];
    
    NSInteger startHeightOffset = [JpUiUtil getStartHeightOffset];
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 5, [JpUiUtil getScreenWidth], [JpUiUtil getScreenHeight]+startHeightOffset);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
    [self.view addSubview:_scrollView];
    
    long y = 2;
    //pickup time
    NSString *service = [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_SERVICE];
    unsigned long long pickupDatetimeLong = [[self.bookingVehicleDetail objectForKey:COLUMN_PICKUP_DATE_TIME] longLongValue];
    NSString *pickupDatetime = [JpDateUtil getDateTimeStrByMilliSecond:pickupDatetimeLong dateFormate:@"EEE, dd MMM yyyy, HH:mm a"];
    UIView *view1 = [self createBoxViewWithStartY:y firstText:service secondText:pickupDatetime tag:0];
    [_scrollView addSubview:view1];
    
    //FROM
    _pickupAddress = [self.bookingVehicleDetail objectForKey:COLUMN_PICKUP_ADDRESS];
    NSString *serviceCd = [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_SERVICE_CD];
    NSString *flightNumber = [self.bookingVehicleDetail objectForKey:COLUMN_FLIGHT_NUMBER];
    if ([serviceCd length]>0 && [VALUE_BOOKING_SERVICE_CD_ARRIVAL isEqualToString:serviceCd] && [flightNumber length]>1 &&
        ![@"<null>" isEqualToString:flightNumber]) {
        _pickupAddress = [NSString stringWithFormat:@"(%@) %@ ", flightNumber, _pickupAddress];
    }  else if ([serviceCd length]>0 && [VALUE_BOOKING_SERVICE_CD_HOURLY isEqualToString:serviceCd]) {
        _pickupAddress = [NSString stringWithFormat:@"(%@ hours) %@ ", [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_HOURS], _pickupAddress];
    }
    
    y += view1.frame.size.height + 5;
    UIView *view2 = [self createBoxViewWithStartY:y firstText:@"From" secondText:_pickupAddress tag:MAP_DIRECTION];
    [_scrollView addSubview:view2];
    y += view2.frame.size.height + 5;
    
    NSString *stop1Address = [self.bookingVehicleDetail objectForKey:COLUMN_STOP1_ADDRESS];
    if (stop1Address && [stop1Address length]>8) {
        UIView *view2s1 = [self createBoxViewWithStartY:y firstText:@"Stop 1 Address" secondText:stop1Address tag:MAP_ROUTE_STOP1];
        [_scrollView addSubview:view2s1];
         y += view2s1.frame.size.height + 5;
    }
    NSString *stop2Address = [self.bookingVehicleDetail objectForKey:COLUMN_STOP2_ADDRESS];
    if (stop2Address && [stop2Address length]>8) {
        UIView *view2s2 = [self createBoxViewWithStartY:y firstText:@"Stop 2 Address" secondText:stop2Address tag:MAP_ROUTE_STOP2];
        [_scrollView addSubview:view2s2];
        y += view2s2.frame.size.height + 5;
    }
    
    //TO
    _destination = [self.bookingVehicleDetail objectForKey:COLUMN_DESTINATION];
    if ([serviceCd length]>0 && [VALUE_BOOKING_SERVICE_CD_DEPARTURE isEqualToString:serviceCd] && [flightNumber length]>1 &&
       ![@"<null>" isEqualToString:flightNumber]) {
        _destination = [NSString stringWithFormat:@"(%@) %@", flightNumber, _destination];
    }
    UIView *view3 = [self createBoxViewWithStartY:y firstText:@"To" secondText:_destination tag:MAP_ROUTE];
    [_scrollView addSubview:view3];
    
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
    [_scrollView addSubview:view4];
    
    //Book by
    NSString *bookByPerson = [NSString stringWithFormat:@"%@ %@ %@", [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_USER_GENDER], [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_USER_FIRST_NAME],[self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_USER_LAST_NAME]];
    y += view4.frame.size.height + 5;
    UIView *view5 = [self createBoxViewWithStartY:y firstText:@"Book by" secondText:bookByPerson tag:CALL_BOOK_BY_USER];
    [_scrollView addSubview:view5];
    y += view5.frame.size.height + 5;
    
    //Driver
    driverView = [self createBoxViewWithStartY:y firstText:@"Driver" secondText:[self.bookingVehicleDetail objectForKey:COLUMN_DRIVER_USER_NAME] tag:CHANGE_DRIVER];
    [_scrollView addSubview:driverView];
    y += driverView.frame.size.height + 5;
    
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
     [_scrollView addSubview:vehicleView];
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
        [_scrollView addSubview:remarkView];
        y += remarkView.frame.size.height + 5;
        
        UIImage *commentImage = [UIImage imageNamed: @"icon_comment_red"];
        UIImageView *commentIV = [[UIImageView alloc] initWithImage: commentImage];
        [commentIV setFrame:CGRectMake(8, 10, 18, 15)];
        [remarkView addSubview:commentIV];
    }
    
    NSString *driverClaimPrice = [self.bookingVehicleDetail objectForKey:COLUMN_DRIVER_CLAIM_PRICE];
    NSString *signaturePath = [self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_SIGNATURE_PATH];
    if (([driverClaimPrice length]>0 && ![@"0.0" isEqualToString:driverClaimPrice] && ![signaturePath isKindOfClass:[NSNull class]]&& [signaturePath length]>10) || ([driverClaimPrice length]==0 || [@"0.0" isEqualToString:driverClaimPrice])) {
    UIImage * squareImg = [UIImage imageNamed:@"bg_btn_square_white"];
    UIView *signatureView = [[UIView alloc] initWithFrame:CGRectMake(8, y, _scrollView.frame.size.width-16, 160)];
    float viewWidth = signatureView.frame.size.width;
    // Button
    UIButton *signatureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signatureBtn.frame = CGRectMake(0,0,signatureView.frame.size.width,160);
    [signatureBtn setBackgroundImage:squareImg forState:UIControlStateNormal];
    [signatureBtn setTag:1];
    if ([driverClaimPrice isKindOfClass:[NSNull class]] || ([driverClaimPrice length]==0 || [@"0.0" isEqualToString:driverClaimPrice])) {
        [signatureBtn addTarget:self action:@selector(onSignatureClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // Signature is attributed text because of the red asterisk
    UILabel *buttonLabel1 = [[UILabel alloc] init];
    buttonLabel1.text= @"Passenger Signature";
    buttonLabel1.textAlignment = NSTextAlignmentCenter;
    buttonLabel1.numberOfLines = 1;
    buttonLabel1.backgroundColor=[UIColor clearColor];
    buttonLabel1.textColor=[UIColor blackColor];
    buttonLabel1.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    [buttonLabel1 setFrame:CGRectMake(0, signatureView.frame.size.height-30, viewWidth, 20)];
    
    UIImage *signatureDefaultImage = [UIImage imageNamed:@"icon_signature_red"];
    NSString *signaturePath = [_bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_SIGNATURE_PATH];
    if (![signaturePath isKindOfClass:[NSNull class]] && [signaturePath length]>10) {
        NSRange range = [signaturePath rangeOfString:@"/" options:NSBackwardsSearch];
        NSString *imageName = [signaturePath substringFromIndex:range.location+1];
        NSString *signaturePath = [JpFileUtil getFullPathWithDirName:@"signature"];
        NSString *fullPath = [signaturePath stringByAppendingPathComponent:imageName];
        
        signatureDefaultImage = [UIImage imageWithContentsOfFile:fullPath];
    }
    _signatureImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _signatureImageBtn.frame = CGRectMake((viewWidth-300)/2, 0, 300, 130);
    _signatureImageBtn.backgroundColor = [UIColor clearColor];
    [_signatureImageBtn setBackgroundImage:signatureDefaultImage forState:UIControlStateNormal];
    if ([driverClaimPrice isKindOfClass:[NSNull class]] || ([driverClaimPrice length]==0 || [@"0.0" isEqualToString:driverClaimPrice])) {
        [_signatureImageBtn addTarget:self action:@selector(onSignatureClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [signatureView addSubview:signatureBtn];
    [signatureView addSubview:_signatureImageBtn];
    [signatureView addSubview:buttonLabel1];
    // [signatureView addSubview:labelRedAsterisk];
    [_scrollView addSubview:signatureView];
    
    y += signatureView.frame.size.height + 5;
    }

    _bookingCompleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bookingCompleteBtn.frame = CGRectMake(8, y+3, [JpUiUtil getScreenWidth]-16, 42);
    [_bookingCompleteBtn setBackgroundColor:[UIColor blackColor]];
    NSString *completeText = @"Complete";
    if ([driverClaimPrice length]>0 && ![@"0.0" isEqualToString:driverClaimPrice]) {
        NSString *driverClaimStatus = [self.bookingVehicleDetail objectForKey:COLUMN_DRIVER_CLAIM_STATUS];
        NSString *driverClaimCurrency = [self.bookingVehicleDetail objectForKey:COLUMN_DRIVER_CLAIM_CURRENCY];
        if ([@"Paid" isEqualToString:driverClaimStatus]) {
            completeText = [NSString stringWithFormat:@"Claim %@%@ (Received)", driverClaimCurrency, driverClaimPrice];
        } else {
            completeText = [NSString stringWithFormat:@"Claim %@%@ (Pending)", driverClaimCurrency, driverClaimPrice];
            [_bookingCompleteBtn addTarget:self action:@selector(onCompleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        [_bookingCompleteBtn addTarget:self action:@selector(onCompleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_bookingCompleteBtn setTitle:completeText forState:UIControlStateNormal];
    [_scrollView addSubview:_bookingCompleteBtn];
    
    y += _bookingCompleteBtn.frame.size.height + 11;
    
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
    
        [_scrollView addSubview:gmsMapView];
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
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, y+8)];
    [[self.navigationController navigationBar] setTintColor:[UIColor whiteColor]];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [backButton setTitle:@" Back" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *copyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [copyButton setTitle:@"Copy" forState:UIControlStateNormal];
    [copyButton addTarget:self action:@selector(onCopyBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *copyButtonItem = [[UIBarButtonItem alloc] initWithCustomView:copyButton];
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
    self.navigationItem.rightBarButtonItem = copyButtonItem;
    
    // blurview
    _mask = [[JpFXBlurView alloc] init];
    _mask.dynamic = YES;
    [_mask.layer displayIfNeeded]; //force immediate redraw
    _mask.frame = CGRectMake(0, 0, [JpUiUtil getScreenWidth], [JpUiUtil getScreenHeight]+[JpUiUtil getStartHeightOffset]);
    _mask.iterations = 2;
    [_mask setBlurEnabled:YES];
    [_mask setBlurRadius:40.0f];
    _mask.hidden = TRUE;
    [self.view addSubview:_mask];
    
    
    float screenWidth = [JpUiUtil getScreenWidth];
    float screenHeight = [JpUiUtil getScreenHeight] + [JpUiUtil getStartHeightOffset];
    driverSelView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-226, screenWidth, 226)];
    driverSelView.backgroundColor = COLOR_GRAY_LIGHT_PRIMARY;
    
    driverPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 56)];
    driverPickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [driverPickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancelClicked)];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    [driverPickerToolbar setItems:barItems animated:YES];
    
    drivers = [[NSMutableArray alloc] init];
    NSString *userId = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID];
    NSString *vehicleCd = [self.bookingVehicleDetail objectForKey:COLUMN_VEHICLE_CD];
    NSString *driverLoginUserId = [self.bookingVehicleDetail objectForKey:COLUMN_DRIVER_LOGIN_USER_ID];
    NSDictionary *parameters = @{KEY_USER_ID:userId, @"vehicleTypeCd":vehicleCd};
    [[ObsWebAPIClient sharedClient] POST:@"web/01/getRelateDriverInfos" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableDictionary *respondDic = responseObject;
        NSString *result = [respondDic valueForKey:KEY_RESULT];
        if ([result isEqualToString:VALUE_SUCCESS]) {
            NSString *data = [respondDic valueForKey:KEY_DATA];
            vehicleInfos = [NSMutableArray arrayWithArray:[data componentsSeparatedByString:@";"]];
            
            int selIndex = 0;
            [self.bookingVehicleDetail objectForKey:COLUMN_DRIVER_USER_NAME];
            
            for (int i=0; i<[vehicleInfos count]; i++) {
                NSString *vehicleInfoStr1 = vehicleInfos[i];
                if ([vehicleInfoStr1 length]>1) {
                    NSArray *vehicleInfo = [vehicleInfoStr1 componentsSeparatedByString:@"_"];
                    NSString *driverName = vehicleInfo[2];
                    [drivers addObject:driverName];
                    if ([driverLoginUserId isEqualToString:vehicleInfo[1]]) {
                        selIndex = i;
                    }
                }
            }
            [driverPV reloadAllComponents];
            [driverPV selectRow:selIndex inComponent:0 animated:YES];
            [driverPV reloadComponent:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    driverPV = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 56, screenWidth, 170)];
    driverPV.delegate = self;
    driverPV.dataSource = self;
    [driverPV setShowsSelectionIndicator:YES];
    
    [driverSelView addSubview:driverPickerToolbar];
    [driverSelView addSubview:driverPV];
    driverSelView.hidden = YES;
    [self.view addSubview:driverSelView];
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
        } else if (tag==CHANGE_DRIVER) {
            [callBtn setImage:[UIImage imageNamed:@"icon_driver_black"] forState:UIControlStateNormal];
            [callBtn addTarget:self action:@selector(onChangeDriver:) forControlEvents:UIControlEventTouchUpInside];
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

- (IBAction)onChangeDriver:(id)sender {
    if ([drivers count]>0) {
        driverSelView.hidden = NO;
    } else {
        [JpUiUtil showAlertWithMessage:@"Can not get drivers, please check your network." title:@""];
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
    } else if (alertView.tag == CHANGE_DRIVER_SUCCESS) {
        NSURLSessionTask *task = [ObsWebAPIClient getObmBookingItemsFromServerWithBlock:^(NSArray *sections, NSDictionary *sectionCellsDic, NSError *error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBookingTableView" object:nil];
                _bookingVehicleDetail = [[ObsDBManager getSharedInstance] getObmBookingVehicleItem:[_bookingVehicleDetail objectForKey:COLUMN_BOOKING_VEHICLE_ITEM_ID]];
                [driverView removeFromSuperview];
                driverView = [self createBoxViewWithStartY:driverView.frame.origin.y firstText:@"Driver" secondText:[self.bookingVehicleDetail objectForKey:COLUMN_DRIVER_USER_NAME] tag:CHANGE_DRIVER];
                [_scrollView addSubview:driverView];
            } else {
                [JpUiUtil showAlertWithMessage:@"Refresh Fail" title:@"Alert"];
            }
        }];
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    }
}

- (IBAction)onClickBackBtn:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCopyBtn:(id)sender
{
    NSString *bookingInfo = [_bookingVehicleDetail objectForKey:COLUMN_BOOKING_NUMBER];
    NSString *paymentMode = [_bookingVehicleDetail objectForKey:COLUMN_PAYMENT_MODE];
    NSString *paymentStatus = [_bookingVehicleDetail objectForKey:COLUMN_PAYMENT_STATUS];
    if ([@"Cash" isEqualToString:paymentMode]) {
        bookingInfo = [NSString stringWithFormat:@"%@\ncollect %@%@ Cash", bookingInfo, [_bookingVehicleDetail objectForKey:COLUMN_PRICE_UNIT], [_bookingVehicleDetail objectForKey:COLUMN_PRICE]];
    } else if ([@"Paid" isEqualToString:paymentStatus]) {
        bookingInfo = [bookingInfo stringByAppendingString:@"\nPaid"];
    } else {
        bookingInfo = [bookingInfo stringByAppendingString:@"\nNot Paid"];
    }
    unsigned long long pickupDatetimeLong = [[self.bookingVehicleDetail objectForKey:COLUMN_PICKUP_DATE_TIME] longLongValue];
    NSString *pickupDatetime = [JpDateUtil getDateTimeStrByMilliSecond:pickupDatetimeLong dateFormate:@"EEE, dd MMM yyyy, HH:mm a"];
    
    bookingInfo = [NSString stringWithFormat:@"%@\n\n%@\n%@\nto %@", bookingInfo, pickupDatetime, _pickupAddress, _destination];
    NSString *stop1Address = [_bookingVehicleDetail objectForKey:COLUMN_STOP1_ADDRESS];
    if (stop1Address && [stop1Address length]>8) {
        bookingInfo = [NSString stringWithFormat:@"%@\nStop1 %@", bookingInfo, [_bookingVehicleDetail objectForKey:COLUMN_STOP1_ADDRESS]];
    }
    NSString *stop2Address = [_bookingVehicleDetail objectForKey:COLUMN_STOP2_ADDRESS];
    if (stop2Address && [stop2Address length]>8) {
        bookingInfo = [NSString stringWithFormat:@"%@\nStop2 %@", bookingInfo, [_bookingVehicleDetail objectForKey:COLUMN_STOP2_ADDRESS]];
    }
    NSString *firstName = [self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_FIRST_NAME];
    NSString *lastName = [self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_LAST_NAME];
    NSString *leadPassenger = [self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_GENDER];
    if (firstName && [firstName length]>1) {
        leadPassenger = [NSString stringWithFormat:@"%@ %@ ", leadPassenger, firstName];
    }
    if (lastName && [lastName length]>1) {
        leadPassenger = [NSString stringWithFormat:@"%@ %@ ", leadPassenger, lastName];
    }
    bookingInfo = [NSString stringWithFormat:@"%@\n\n%@ - %@ pax\nPassenger : %@ %@\n\nFrom %@", bookingInfo, [_bookingVehicleDetail objectForKey:COLUMN_VEHICLE], [_bookingVehicleDetail objectForKey:COLUMN_NUMBER_OF_PASSENGER], leadPassenger, [_bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_MOBILE_NUMBER], [JpDataUtil getDicFromUDByKey:KEY_OBS_USER_NAME]];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:bookingInfo];
    [JpUiUtil showAlertWithMessage:@"Success" title:@""];
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

- (IBAction)onCompleteBtn:(id)sender {
    [_bookingCompleteVC popupBookingItemDialog:self.view bookingItemId:[_bookingVehicleDetail objectForKey:COLUMN_BOOKING_VEHICLE_ITEM_ID] currency:[_bookingVehicleDetail objectForKey:COLUMN_DRIVER_CLAIM_CURRENCY] price:[_bookingVehicleDetail objectForKey:COLUMN_DRIVER_CLAIM_PRICE]];
}

-(void)delegateOkBtnEvent {
    _bookingVehicleDetail = [[ObsDBManager getSharedInstance] getObmBookingVehicleItem:[_bookingVehicleDetail objectForKey:COLUMN_BOOKING_VEHICLE_ITEM_ID]];
    [_bookingCompleteBtn setTitle:[NSString stringWithFormat:@"Claim %@%@ (Pending)", [_bookingVehicleDetail objectForKey:COLUMN_DRIVER_CLAIM_CURRENCY], [_bookingVehicleDetail objectForKey:COLUMN_DRIVER_CLAIM_PRICE]] forState:UIControlStateNormal];
    [_bookingCompleteVC removeBookingItemDialog];
    _mask.hidden = TRUE;
    
}
-(void)delegateCancelBtnEvent {

    [_bookingCompleteVC removeBookingItemDialog];
    _mask.hidden = TRUE;
}

-(void)pickerDoneClicked
{
    if (vehicleInfoStr && [vehicleInfoStr length]>1) {
        @try {
            NSArray *vehicleInfo = [vehicleInfoStr componentsSeparatedByString:@"_"];
            NSString *vehicleId = vehicleInfo[0];
            NSString *driverLoginUserId = vehicleInfo[1];
            NSString *driverUserName = vehicleInfo[2];
            NSString *driverMobileNumber = vehicleInfo[3];
            NSString *driverVehicle = vehicleInfo[4];
            NSString *assignDriverUserId = vehicleInfo[5];
            NSString *assignDriverUserName = vehicleInfo[6];
            NSString *assignDriverMobilePhone = vehicleInfo[7];
            
            NSString *oldDriverLoginUserId = [self.bookingVehicleDetail objectForKey:COLUMN_DRIVER_LOGIN_USER_ID];
            NSString *bookingVehicleItemId = [self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_VEHICLE_ITEM_ID];
            if (![oldDriverLoginUserId isEqualToString:driverLoginUserId]) {
                NSString *userId = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID];
                NSString *userName = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_NAME];
                
                NSDictionary *parameters = @{KEY_USER_ID:userId, KEY_USER_NAME:userName, @"driverUserId":vehicleId, @"bookingVehicleItemId":bookingVehicleItemId, @"driverUserName":driverUserName, @"deviceName":[JpSystemUtil getDeviceName], @"isDriverAccept":@"no", @"past":@"yes",@"driverMobileNumber":driverMobileNumber,@"driverVehicle":driverVehicle,@"driverLoginUserId":driverLoginUserId,@"assignDriverUserId":assignDriverUserId, @"assignDriverUserName":assignDriverUserName, @"assignDriverMobilePhone":assignDriverMobilePhone};
                
                [[ObsWebAPIClient sharedClient] POST:@"web/01/assignDriver" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSMutableDictionary *respondDic = responseObject;
                    NSString *result = [respondDic valueForKey:KEY_RESULT];
                    if ([result isEqualToString:VALUE_SUCCESS]) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Success" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        alertView.tag = CHANGE_DRIVER_SUCCESS;
                        [alertView show];
                        
                    } else {
                        [JpUiUtil showAlertWithMessage:@"Fail" title:@""];
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [JpUiUtil showAlertWithMessage:@"Fail" title:@""];
                }];
            }
        }
        @catch (NSException *exception) {
            [JpUiUtil showAlertWithMessage:@"Fail" title:@""];
        }
    }
    driverSelView.hidden = YES;
}
-(void)pickerCancelClicked
{
    driverSelView.hidden = YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [drivers count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [drivers objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    vehicleInfoStr = [vehicleInfos objectAtIndex:row];
}


- (void) onSignatureClicked: (id)sender
{
    JBSignatureController *signatureController = [[JBSignatureController alloc] init];
    signatureController.delegate = self;
    [self presentViewController:signatureController animated:YES completion:nil];
}

// Signature methods
-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(JBSignatureController *)sender
{
    NSString *bookingNumber = [_bookingVehicleDetail objectForKey:COLUMN_BOOKING_NUMBER];
    unsigned long long pickupDatetimeLong = [[self.bookingVehicleDetail objectForKey:COLUMN_PICKUP_DATE_TIME] longLongValue];
    NSString *pickupDatetime = [JpDateUtil getDateTimeStrByMilliSecond:pickupDatetimeLong dateFormate:@"yyyyMMddHHmm"];
    NSString *imageName = [NSString stringWithFormat:@"%@%@.jpg",bookingNumber,pickupDatetime];
    NSString *signaturePath = [JpFileUtil getFullPathWithDirName:@"signature"];
    NSString *fullPath = [signaturePath stringByAppendingPathComponent:imageName];
    
    @try {
        if (signatureImage) {
            NSString *text = [NSString stringWithFormat:@"only valid for %@ at %@", bookingNumber,  [JpDateUtil getCurrentDateTimeWithAmPmStr]];
            signatureImage = [JpFileUtil addText:signatureImage text:text withRect:CGRectMake(5, signatureImage.size.height-30, signatureImage.size.width, 30)];
            [_signatureImageBtn setBackgroundImage:signatureImage forState:UIControlStateNormal];
            [JpFileUtil saveImage:signatureImage imageType:IMAGE_TYPE_JPG fileName:imageName subDirectory:signaturePath];
            
            NSString *bookingVehicleItemId = [_bookingVehicleDetail objectForKey:COLUMN_BOOKING_VEHICLE_ITEM_ID];
            [ObsWebAPIClient uploadSignature:fullPath imagName:imageName bookingVehicleItemId:bookingVehicleItemId];
            NSURLSessionTask *task = [ObsWebAPIClient getObmBookingItemsFromServerWithBlock:^(NSArray *sections, NSDictionary *sectionCellsDic, NSError *error) {
                NSMutableArray *signatureInfoArr = [JpDataUtil getArrFromUDByKey:KEY_SIGNATURE_INFOS];
                NSString *signatureInfo = [NSString stringWithFormat:@"%@,%@", imageName, bookingVehicleItemId];
                if (!error) {
                    if (![signatureInfoArr isKindOfClass:[NSNull class]] && [signatureInfoArr indexOfObject:signatureInfo] != NSNotFound) {
                        if ([signatureInfoArr count]==1) {
                            [JpDataUtil remove:KEY_SIGNATURE_INFOS];
                        } else {
                            signatureInfoArr = [signatureInfoArr mutableCopy];
                            [signatureInfoArr removeObject:signatureInfo];
                            [JpDataUtil saveDataToUDForKey:KEY_SIGNATURE_INFOS value:signatureInfoArr];
                        }
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBookingTableView" object:nil];
                } else {
                    if (![signatureInfoArr isKindOfClass:[NSNull class]] && [signatureInfoArr count]>0) {
                        if ([signatureInfoArr indexOfObject:signatureInfo] == NSNotFound) {
                            signatureInfoArr = [signatureInfoArr mutableCopy];
                            [signatureInfoArr addObject:signatureInfo];
                            [JpDataUtil saveDataToUDForKey:KEY_SIGNATURE_INFOS value:signatureInfoArr];
                        }
                    } else {
                        NSMutableArray *newSignatureInfoArr = [[NSMutableArray alloc] init];
                        [newSignatureInfoArr addObject:signatureInfo];
                        [JpDataUtil saveDataToUDForKey:KEY_SIGNATURE_INFOS value:newSignatureInfoArr];
                    }
                }
            }];
            [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
        } else {
            [_signatureImageBtn setBackgroundImage:Nil forState:UIControlStateNormal];
            [JpFileUtil deleteImage:imageName subDirectory:signaturePath];
        }
        [sender dismissViewControllerAnimated:YES completion:Nil];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)signatureCancelled:(JBSignatureController *)sender
{
    [sender dismissViewControllerAnimated:YES completion:Nil];
}

-(void)signatureCleared:(UIImage *)clearedSignatureImage signatureController:(JBSignatureController *)sender
{
    [sender clearSignature];
}

@end
