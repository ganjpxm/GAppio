//
//  ViewController.m
//  obsc
//
//  Created by Johnny on 7/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "JpWebSampleVC.h"
#import "JpUiUtil.h"
#import "JpActivityIndicatorView.h"
#import "WebViewJavascriptBridge.h"
#import "ViewController.h"

@interface JpWebSampleVC ()

@property (strong, nonatomic) WebViewJavascriptBridge   *jsBridge;

@end

@implementation JpWebSampleVC

- (void)viewDidLoad
{
    [self setTitle:@"Limousine Transport"];
    [super viewDidLoad];
    
    [WebViewJavascriptBridge enableLogging];
    _jsBridge = [WebViewJavascriptBridge bridgeForWebView:super.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    [_jsBridge registerHandler:@"backToHome" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
    }];
    [_jsBridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
        NSLog(@"objc got response! %@", responseData);
    }];
    [_jsBridge callHandler:@"testJavascriptHandler" data:[NSDictionary dictionaryWithObject:@"before ready" forKey:@"foo"]];
    
    [super loadPage:@"Web/index"];
    
    [_jsBridge send:@"A string sent from ObjC after Webview has loaded." responseCallback:^(id responseData) {
        NSLog(@"objc got response! %@", responseData);
    }];
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
