//
//  ViewController.m
//  obsc
//
//  Created by Johnny on 7/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "JpWebVC.h"
#import "JpUiUtil.h"
#import "JpActivityIndicatorView.h"
#import "WebViewJavascriptBridge.h"
#import "NSString+Jp.h"
#import "JpUiUtil.h"

@interface JpWebVC ()

@property (nonatomic, assign) BOOL                      mFirstLoad;
@property (nonatomic, strong) UIView                    *mMaskView;
@property (nonatomic, strong) NSTimer                   *mWebViewTimeoutTimer;
@property (nonatomic, strong) JpActivityIndicatorView   *mActivityIndicatorView;

@end

@implementation JpWebVC
@synthesize iWebView;
- (void)viewDidLoad
{
    _mFirstLoad = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSInteger startHeightOffset = [JpUiUtil getStartHeightOffset];
    iWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [JpUiUtil getScreenWidth], [JpUiUtil getScreenHeight]+startHeightOffset)];
    iWebView.scalesPageToFit = YES;
    [iWebView.scrollView setContentSize: CGSizeMake(iWebView.frame.size.width, iWebView.scrollView.contentSize.height)];
    [iWebView setUserInteractionEnabled:YES];
    iWebView.backgroundColor = [UIColor clearColor];
    [iWebView setOpaque:NO];
    iWebView.scrollView.scrollEnabled = NO;
    [self.view addSubview:iWebView];
    
    // Create a mMaskView
    _mMaskView = [[UIView alloc] initWithFrame:self.view.bounds];
    _mMaskView.backgroundColor = [UIColor whiteColor];
    _mMaskView.alpha = 0.1;
    _mMaskView.hidden = YES;
    [self.view addSubview:_mMaskView];

    _mActivityIndicatorView = [[JpActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge
                              text:NSLocalizedString(@"Loading...",@"")
                              textColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
                              indicatorColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
                              superview:self.view];
    _mActivityIndicatorView.hidden = YES;
    [self.view addSubview:_mActivityIndicatorView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self showMaskView];
    
    [self loadPage:_iCurrenURL];
}

- (void)loadPage:(NSString *)urlString {
    if ([urlString length]>0) {
        if ([urlString containsString:@"Web/"]) {
            [self loadPageFromLocal:urlString];
        } else {
            [self loadPageFromServer:urlString];
        }
    }
}

- (void)loadPageFromServer:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [iWebView loadRequest:request];
}

- (void)loadPageFromLocal:(NSString *)filePath {
    filePath = [[NSBundle mainBundle] pathForResource:filePath ofType:@"html"];
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [iWebView loadRequest:urlReq];
}

- (void)doTimeout
{
    [self hideMaskView];
    [JpUiUtil showAlertWithMessage:@"Time Out, Please try again later." title:@"Alert"];
}

- (void)hideMaskView
{
    [_mActivityIndicatorView stopAnimating];
    _mActivityIndicatorView.hidden = YES;
    _mMaskView.hidden = YES;
}

- (void)showMaskView
{
    _mActivityIndicatorView.hidden = NO;
    [_mActivityIndicatorView startAnimating];
    _mMaskView.hidden = NO;
}

- (void)showMaskView:(NSString *)text
{
    _mActivityIndicatorView.hidden = NO;
    [_mActivityIndicatorView startAnimating];
    _mActivityIndicatorView.text = text;
    _mMaskView.hidden = NO;
}


//UIWebViewDelegate method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (!_mFirstLoad) {
        [self showMaskView];
    }
    if (![_mWebViewTimeoutTimer isValid]) {
        _mWebViewTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:90 target:self selector:@selector(doTimeout) userInfo:nil repeats:NO];
    }
    
    NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    NSLog(@"%@", requestString);
//    NSString *mUserId = [_webView  stringByEvaluatingJavaScriptFromString:@"document.getElementById('mUserId').value"];
    return YES;
}

//UIWebViewDelegate method
- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [self hideMaskView];
    [_mWebViewTimeoutTimer invalidate];
    _mFirstLoad = NO;
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
}

//UIWebViewDelegate method
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideMaskView];
    [JpUiUtil showAlertWithMessage:@"Server Down, Please try again later." title:@"Alert"];
}

@end
