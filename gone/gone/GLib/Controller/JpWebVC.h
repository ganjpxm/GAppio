//
//  JpWebVC.h
//  GOne
//
//  Created by Johnny on 7/3/15.
//  Copyright (c) 2015 ganjp. All rights reserved.
//
#import "JpVC.h"

@interface JpWebVC : JpVC<UIWebViewDelegate>

@property (nonatomic, strong) NSString   *iCurrenURL;
@property (nonatomic, strong) UIWebView  *iWebView;

- (void)loadPage:(NSString *)urlString;
- (void)hideMaskView;
- (void)showMaskView;
- (void)showMaskView:(NSString *)text;

//UIWebViewDelegate method
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)aRequest navigationType:(UIWebViewNavigationType)aNavigationType;
- (void)webViewDidFinishLoad:(UIWebView *)aWebView;
@end
