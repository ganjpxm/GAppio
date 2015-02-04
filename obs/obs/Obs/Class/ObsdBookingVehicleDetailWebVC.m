//
//  ViewController.m
//  obsc
//
//  Created by Johnny on 7/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "ObsdBookingVehicleDetailWebVC.h"
#import "JpDateUtil.h"

@interface ObsdBookingVehicleDetailWebVC ()

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSDictionary *bookingVehicleDetail;

@end

@implementation ObsdBookingVehicleDetailWebVC
- (id)init:(NSString *)from data:(NSDictionary *)bookingVehicleDetail
{
    self = [super init];
    if (self) {
        self.from = from;
        self.bookingVehicleDetail = bookingVehicleDetail;
    }
    return self;
}

- (void)viewDidLoad
{
    [self setTitle:[self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_NUMBER]];
    [super viewDidLoad];
    self.webView.scrollView.scrollEnabled = YES;
    [super loadPage:@"Web/obsdBookingVehicleDetail"];
    self.webView.delegate = self;
}

//UIWebViewDelegate method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    return YES;
}

//UIWebViewDelegate method
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    NSMutableString* js = [NSMutableString stringWithFormat:@"%@",@"function mainF() { "];
//    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('bookingNumber').innerHTML='%@';",js,[self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_NUMBER]];

    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('service').innerHTML='%@';",js,[self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_SERVICE]];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('from').innerHTML='%@';",js, [self.bookingVehicleDetail objectForKey:COLUMN_PICKUP_ADDRESS]];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('to').innerHTML='%@';",js, [self.bookingVehicleDetail objectForKey:COLUMN_DESTINATION]];
    
    unsigned long long pickupDatetimeLong = [[self.bookingVehicleDetail objectForKey:COLUMN_PICKUP_DATE_TIME] longLongValue];
    NSString *pickupDatetime = [JpDateUtil getDateTimeStrByMilliSecond:pickupDatetimeLong dateFormate:@"EEE, dd MMM yyyy, HH:mm"];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('pickupDatetime').innerHTML='%@';",js,pickupDatetime];
//
//    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('noOfPassenger').innerHTML='%@';",js,[self.bookingVehicleDetail objectForKey:COLUMN_NUMBER_OF_PASSENGER]];
//    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('payment').innerHTML='%@';",js,[self.bookingVehicleDetail objectForKey:COLUMN_PAYMENT_STATUS]];

//    
    NSString *leadPassenger = [NSString stringWithFormat:@"%@ %@ %@",[self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_GENDER],[self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_FIRST_NAME], [self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_LAST_NAME]];
    NSString *leadPassengerMobileNumber = [self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_MOBILE_NUMBER];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('leadPassenger').innerHTML='%@';",js, leadPassenger];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('leadPassengerMobileNumber').href='tel:%@';",js, leadPassengerMobileNumber];

    NSString *bookByPerson = [NSString stringWithFormat:@"%@ %@",[self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_USER_NAME],[self.bookingVehicleDetail objectForKey:COLUMN_BOOKING_USER_SURNAME]];
    NSString *bookByMobileNumber = [self.bookingVehicleDetail objectForKey:COLUMN_LEAD_PASSENGER_MOBILE_NUMBER];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('bookByPerson').innerHTML='%@';",js, bookByPerson];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('bookByMobileNumber').href='tel:%@';", js, bookByMobileNumber];
//
//    NSString *createByPerson = [self.bookingVehicleDetail objectForKey:COLUMN_OPERATOR_NAME];
//    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('createByPerson').innerHTML='%@';",js, createByPerson];
//    
//    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('remarks').innerHTML='%@';",js, [self.bookingVehicleDetail objectForKey:COLUMN_REMARK]];
    
    
    
    js = [NSMutableString stringWithFormat:@"%@%@",js,@"} mainF();"];
    [webView  stringByEvaluatingJavaScriptFromString:js];
}



@end
