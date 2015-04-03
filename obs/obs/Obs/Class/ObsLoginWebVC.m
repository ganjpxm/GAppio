//
//  DriverLoginWebVC.m
//  obs
//
//  Created by Johnny on 7/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "ObsLoginWebVC.h"
#import "WebViewJavascriptBridge.h"
#import "JpUiUtil.h"
#import "ObsWebAPIClient.h"
#import "JpDataUtil.h"
#import "ObsTabBC.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "ObsWebAPIClient.h"

@interface ObsLoginWebVC ()

@property (strong, nonatomic) WebViewJavascriptBridge   *mWebViewJsBridge;

@end

@implementation ObsLoginWebVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [self setTitle:@"Limousine Transport"];
    [super viewDidLoad];
    self.screenName = SCREEN_LOGIN;
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    
    [WebViewJavascriptBridge enableLogging];
    _mWebViewJsBridge = [WebViewJavascriptBridge bridgeForWebView:super.iWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
            //if ([[JpDataUtil getValueFromUDByKey:KEY_NETWORK_STATUS] isEqualToString:VALUE_YES]) {
            [super showMaskView:@"Processing.."];
            NSDictionary *dic = data;
            if ([dic count]>0 && [[dic objectForKey:@"action"] isEqualToString:@"login"]) {
                NSString *mobileNumber = [super.iWebView  stringByEvaluatingJavaScriptFromString:@"document.getElementById('mobileNumber').value"];
                NSString *password = [super.iWebView  stringByEvaluatingJavaScriptFromString:@"document.getElementById('password').value"];
                NSDictionary *parameters = @{KEY_LOGIN_USER_CD_OR_EMAIL_OR_MOBILE_NUMBER: mobileNumber, KEY_LOGIN_USER_PASSWORD: password};
                [[ObsWebAPIClient sharedClient] POST:@"allOrg/login" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSMutableDictionary *respondDic = responseObject;
                    NSString *result = [respondDic valueForKey:KEY_RESULT];
                    if ([result isEqualToString:VALUE_SUCCESS]) {
                        NSString *userCd = [respondDic objectForKey:KEY_USER_CD_OBS];
                        [JpDataUtil saveDataToUDForKey:KEY_USER_CD_OBS value:userCd];
                        [JpDataUtil saveDataToUDForKey:KEY_OBS_USER_ID value:[respondDic objectForKey:KEY_OBS_USER_ID]];
                        [JpDataUtil saveDataToUDForKey:KEY_OBS_USER_NAME value:[respondDic objectForKey:KEY_OBS_USER_NAME]];
                        
                        ObsTabBC *tabBC = [[ObsTabBC alloc] init];
                        [self presentViewController:tabBC animated:YES completion:nil];
                        [super hideMaskView];
                    } else {
                        [super hideMaskView];
                        [JpUiUtil showAlertWithMessage:@"Mobile No. or Password is wrong" title:@"Alert"];
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [super hideMaskView];
                    [JpUiUtil showAlertWithMessage:@"Login Fail" title:@"Alert"];
                }];
            } else {
                [super hideMaskView];
                [JpUiUtil showAlertWithMessage:@"Login Fail, please check your network." title:@"Alert"];
            }
    }];
    
    [super loadPage:@"Web/driverLogin"];
}

//UIWebViewDelegate method
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)aRequest navigationType:(UIWebViewNavigationType)aNavigationType
{
    [super webView:aWebView shouldStartLoadWithRequest:aRequest navigationType:aNavigationType];
    return YES;
}

//UIWebViewDelegate method
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
}


@end
