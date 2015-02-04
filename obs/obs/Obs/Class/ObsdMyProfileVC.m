//
//  ObscMyProfileVC.m
//  obsc
//
//  Created by Johnny on 14/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "ObsdMyProfileVC.h"
#import "JpDataUtil.h"
#import "NSString+Jp.h"

@interface ObsdMyProfileVC ()

@end

@implementation ObsdMyProfileVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[GoogleAnalyticsUtil sendScreen:SCREEN_PROFILE];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [super loadPage:@"Web/obsdMyProfile"];
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
    
    NSString *userCd = [JpDataUtil getValueFromUDByKey:KEY_USER_CD_OBSD];
    NSDictionary *userDic = [JpDataUtil getDicFromUDByKey:userCd];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('myName').innerHTML='%@';",js,[userDic objectForKey:KEY_USER_NAME_OBSD]];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('mobileNumber').innerHTML='%@';",js,[userDic objectForKey:KEY_USER_MOBILE_PHONE_OBSD]];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('email').innerHTML='%@';",js,[userDic objectForKey:KEY_USER_EMAIL_OBSD]];
    NSString *items = [userDic objectForKey:KEY_USER_EXTEND_ITEMS_OBSD];
    NSDictionary *itemDic = [items toDic];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('make').innerHTML='%@';",js,[itemDic objectForKey:@"vehicleMake"]];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('model').innerHTML='%@';",js,[itemDic objectForKey:@"vehicleModel"]];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('vehicleNumber').innerHTML='%@';",js,[itemDic objectForKey:@"vehicleNo"]];
    js = [NSMutableString stringWithFormat:@"%@ document.getElementById('color').innerHTML='%@';",js,[itemDic objectForKey:@"vehicleColor"]];
    
    js = [NSMutableString stringWithFormat:@"%@%@",js,@"} mainF();"];
    [webView  stringByEvaluatingJavaScriptFromString:js];
}

@end
