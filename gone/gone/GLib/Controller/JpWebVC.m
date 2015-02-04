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

@property (nonatomic, assign) BOOL firstLoad;
@property (nonatomic, strong) UIView                    *mask;
@property (nonatomic, strong) NSTimer                   *webViewTimeoutTimer;
@property (nonatomic, strong) JpActivityIndicatorView   *activityIndicatorView;

@end

@implementation JpWebVC
@synthesize webView;
- (void)viewDidLoad
{
    _firstLoad = YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSInteger startHeightOffset = [JpUiUtil getStartHeightOffset];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [JpUiUtil getWindowWidth], [JpUiUtil getWindowHeight]+startHeightOffset)];
    webView.scalesPageToFit = YES;
    [webView.scrollView setContentSize: CGSizeMake(webView.frame.size.width, webView.scrollView.contentSize.height)];
    [webView setUserInteractionEnabled:YES];
    webView.backgroundColor = [UIColor clearColor];
    [webView setOpaque:NO];
    webView.scrollView.scrollEnabled = NO;
    [self.view addSubview:webView];
    
    // Create a mask
    _mask = [[UIView alloc] initWithFrame:self.view.bounds];
    _mask.backgroundColor = [UIColor whiteColor];
    _mask.alpha = 0.1;
    _mask.hidden = YES;
    [self.view addSubview:_mask];

    _activityIndicatorView = [[JpActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge
                              text:NSLocalizedString(@"Loading...",@"")
                              textColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
                              indicatorColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
                              superview:self.view];
    _activityIndicatorView.hidden = YES;
    [self.view addSubview:_activityIndicatorView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self showMask];
    
    [self loadPage:_currenURL];
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
    [webView loadRequest:request];
}

- (void)loadPageFromLocal:(NSString *)filePath {
    filePath = [[NSBundle mainBundle] pathForResource:filePath ofType:@"html"];
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [webView loadRequest:urlReq];
}

- (void)doTimeout
{
    [self hideMask];
    [JpUiUtil showAlertWithMessage:@"Time Out, Please try again later." title:@"Alert"];
}

- (void)hideMask
{
    [_activityIndicatorView stopAnimating];
    _activityIndicatorView.hidden = YES;
    _mask.hidden = YES;
}

- (void)showMask
{
    _activityIndicatorView.hidden = NO;
    [_activityIndicatorView startAnimating];
    _mask.hidden = NO;
}

- (void)showMask:(NSString *)text
{
    _activityIndicatorView.hidden = NO;
    [_activityIndicatorView startAnimating];
    _activityIndicatorView.text = text;
    _mask.hidden = NO;
}


//UIWebViewDelegate method
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (!_firstLoad) {
        [self showMask];
    }
    if (![_webViewTimeoutTimer isValid]) {
        _webViewTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:90 target:self selector:@selector(doTimeout) userInfo:nil repeats:NO];
    }
    
    NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    NSLog(@"%@", requestString);
//    NSString *mUserId = [_webView  stringByEvaluatingJavaScriptFromString:@"document.getElementById('mUserId').value"];
    return YES;
}

//UIWebViewDelegate method
- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    [self hideMask];
    [_webViewTimeoutTimer invalidate];
    _firstLoad = NO;
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
}

//UIWebViewDelegate method
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideMask];
    [JpUiUtil showAlertWithMessage:@"Server Down, Please try again later." title:@"Alert"];
}

@end
