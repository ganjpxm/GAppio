//
//  JpViewController.m
//  JpSample
//
//  Created by Johnny on 23/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "JpVC.h"
#import "UIButton+Jp.h"
#import "JpDataUtil.h"
#import "JpUiUtil.h"
#import "JpSystemUtil.h"

@interface JpVC ()

@end

@implementation JpVC

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent; //UIStatusBarStyleDefault;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIViewController*)initWithNib
{
    NSString *className = NSStringFromClass([self class]);
    self = [self initWithNibName:className bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [JpSystemUtil setNavAndStatusbarStytle:self];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    //self.navigationItem.leftBarButtonItem = [self getBackButtonItem];
    
    //Register with NSNotificationCenter
    for (NSString *notification in [self listNotificationInterests]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:notification object:nil];
    }
}

- (UIBarButtonItem *) getBackButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@" Back" forState:UIControlStateNormal];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backButtonItem;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Helpers
- (UIViewController*)getViewControllerWithClassName:(NSString*)className
{
    if ([className length] <= 0)
        return nil;
    
    //Dynamically load the class
    Class theClass = NSClassFromString(className);
    if (theClass == nil)
        return nil;
    
    NSObject* myViewController = [[theClass alloc] init];
    if (myViewController == nil)
        return nil;
    if ([myViewController isMemberOfClass:[UIViewController class]])
        return nil;
    
    return (UIViewController*)myViewController;
}

#pragma mark - Nav Bar Back Btn
- (IBAction)onClickBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NSNotificationCenter
- (NSArray *)listNotificationInterests
{
    return [NSArray arrayWithObjects:nil]; //applicationDidEnterBackground
}
- (void)handleNotification:(NSNotification *)notification
{
    
}

@end
