//
//  ObscMyProfileVC.m
//  obsc
//
//  Created by Johnny on 14/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "ObsMyProfileVC.h"
#import "JpDataUtil.h"
#import "NSString+Jp.h"
#import "JpUiUtil.h"

@interface ObsMyProfileVC ()

@end

@implementation ObsMyProfileVC

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
    [self.iWebView setFrame:CGRectMake(0, 5, [JpUiUtil getScreenWidth], [JpUiUtil getScreenHeight]-35)];
    // Do any additional setup after loading the view.
    [super loadPage:[NSString stringWithFormat:@"%@free/01/driver/profile?isApp=yes&driverUserId=%@", URL_HOST, [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID]] ];
    self.iWebView.delegate = self;
}

//UIWebViewDelegate method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    NSString *url = [[request URL] absoluteString];
    if ([url containsString:@"driver/profile"]) {
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        self.navigationItem.leftBarButtonItem = [self getBackButtonItem];
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    
//    NSString *userCd = [JpDataUtil getValueFromUDByKey:KEY_USER_CD];
//    NSDictionary *userDic = [JpDataUtil getDicFromUDByKey:userCd];
//    [userDic objectForKey:KEY_USER_NAME]
}

- (IBAction)onClickBackBtn:(id)sender
{
    if ([self.iWebView canGoBack]) {
        [self.iWebView goBack];
    }
}

@end
