//
//  ViewController.m
//  obsc
//
//  Created by Johnny on 7/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "DriverLoginWebVC.h"
#import "WebViewJavascriptBridge.h"
#import "JpUiUtil.h"
#import "ObsWebAPIClient.h"
#import "JpDataUtil.h"
#import "ObsdTabBC.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface DriverLoginWebVC ()

@property (strong, nonatomic) WebViewJavascriptBridge   *jsBridge;

@end

@implementation DriverLoginWebVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:SCREEN_LOGIN];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewDidLoad
{
    [self setTitle:@"Driver App"];
    [super viewDidLoad];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    
    [WebViewJavascriptBridge enableLogging];
    _jsBridge = [WebViewJavascriptBridge bridgeForWebView:super.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
      if ([[JpDataUtil getValueFromUDByKey:KEY_NETWORK_STATUS_OBSD] isEqualToString:VALUE_YES]) {
        [super showMask:@"Processing.."];
        NSDictionary *dic = data;
        if ([dic count]>0 && [[dic objectForKey:@"action"] isEqualToString:@"login"]) {
            NSString *userCd = [super.webView  stringByEvaluatingJavaScriptFromString:@"document.getElementById('userCd').value"];
            NSString *password = [super.webView  stringByEvaluatingJavaScriptFromString:@"document.getElementById('password').value"];
            NSDictionary *dbUserDic = [JpDataUtil getDicFromUDByKey:userCd];
            if (dbUserDic && [dbUserDic count]>0) {
                [JpDataUtil saveDataToUDForKey:KEY_USER_CD_OBSD value:userCd];
                [JpDataUtil saveDataToUDForKey:KEY_USER_ID_OBSD value:[dbUserDic objectForKey:KEY_USER_ID_OBSD]];
                [JpDataUtil saveDataToUDForKey:KEY_USER_NAME_OBSD value:[dbUserDic objectForKey:KEY_USER_NAME_OBSD]];
                ObsdTabBC *tabBC = [[ObsdTabBC alloc] init];
                [self presentViewController:tabBC animated:YES completion:nil];
                [super hideMask];
            } else {
                NSDictionary *parameters = @{@"userCdOrEmail": userCd, @"userPassword": password};
                [[ObsWebAPIClient sharedClient] POST:[LOGIN_ORG_CD stringByAppendingString:@"/driver/login"] parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSDictionary *respondDic = responseObject;
                    NSString *result = [respondDic valueForKey:KEY_RESULT];
                    
                    if ([result isEqualToString:VALUE_SCCESS]) {
                        [JpDataUtil saveDataToUDForKey:userCd value:respondDic];
                        [JpDataUtil saveDataToUDForKey:KEY_USER_CD_OBSD value:userCd];
                        [JpDataUtil saveDataToUDForKey:KEY_USER_ID_OBSD value:[respondDic objectForKey:KEY_USER_ID_OBSD]];
                        [JpDataUtil saveDataToUDForKey:KEY_USER_NAME_OBSD value:[respondDic objectForKey:KEY_USER_NAME_OBSD]];
                        
                        ObsdTabBC *tabBC = [[ObsdTabBC alloc] init];
                        [self presentViewController:tabBC animated:YES completion:nil];
                        [super hideMask];
                    } else {
                        [super hideMask];
                        [JpUiUtil showAlertWithMessage:@"Mobile No. or Password is wrong" title:@"Alert"];
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [super hideMask];
                    [JpUiUtil showAlertWithMessage:@"Login Fail" title:@"Alert"];
                }];
            }
        } else {
            [super hideMask];
            [JpUiUtil showAlertWithMessage:@"Login Fail" title:@"Alert"];
        }
      } else {
          [JpUiUtil showAlertWithMessage:@"Network is not available" title:@"Alert"];
      }
    }];
    
    [_jsBridge send:@{@"userName":@"ganjp", @"password":@"1"} responseCallback:^(id responseData) {
        NSLog(@"objc got response! %@", responseData);
    }];

    [super loadPage:@"Web/driverLogin"];
    
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
}



@end
