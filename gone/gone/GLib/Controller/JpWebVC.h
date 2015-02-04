//
//  ViewController.h
//  obsc
//
//  Created by Johnny on 7/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//
#import "JpVC.h"

@interface JpWebVC : JpVC<UIWebViewDelegate>

@property (nonatomic, strong) NSString   *currenURL;
@property (nonatomic, strong) UIWebView  *webView;

- (void)loadPage:(NSString *)urlString;
- (void)hideMask;
- (void)showMask;
- (void)showMask:(NSString *)text;

//UIWebViewDelegate method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidFinishLoad:(UIWebView *)aWebView;
@end
