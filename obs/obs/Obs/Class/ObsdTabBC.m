//
//  JpTabBC.m
//  JpSample
//
//  Created by Johnny on 11/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "ObsdTabBC.h"
#import "ObsdDriverPastVC.h"
#import "JpNC.h"
#import "ObsdDriverUpcomingVC.h"
#import "ObsdMoreVC.h"
#import "ObsdMyProfileVC.h"
#import "JpApplication.h"


@interface ObsdTabBC ()

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end

@implementation ObsdTabBC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Configure tab and Nav controllers and lay it on window
	[self configureTabsAndNavigationControllers];
    [self.view addSubview:self.tabBarController.view];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void) configureTabsAndNavigationControllers {
    // Home
	ObsdDriverUpcomingVC *upcomingBookingVC = [[ObsdDriverUpcomingVC alloc] init];
    [upcomingBookingVC setTitle:@"Upcoming Booking"];
	UITabBarItem *upcomingBookingTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Upcoming",@"Upcoming") image:[UIImage imageNamed:@"icon_booking_add_gray"] tag:0];
    upcomingBookingVC.tabBarItem = upcomingBookingTabBarItem;
	JpNC *bookingAddNC = [[JpNC alloc] init];
	[bookingAddNC pushViewController:upcomingBookingVC animated:NO];
    [bookingAddNC.navigationBar setBarStyle:UIBarStyleBlack];
    
    ObsdDriverPastVC * bookingHistoryVC = [[ObsdDriverPastVC alloc] init];
    [bookingHistoryVC setTitle:@"Booking History"];
    UITabBarItem *bookingHistoryTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"History",@"History") image:[UIImage imageNamed:@"icon_booking_history_gray"] tag:1];
    bookingHistoryVC.tabBarItem = bookingHistoryTabBarItem;
    JpNC *bookingHistoryNC = [[JpNC alloc] init];
    [bookingHistoryNC pushViewController:bookingHistoryVC animated:NO];
    [[bookingHistoryNC navigationBar] setTintColor:[UIColor blackColor]];
    
    ObsdMyProfileVC *myProfileVC = [[ObsdMyProfileVC alloc] init];
    [myProfileVC setTitle:@"My Profile"];
	UITabBarItem *myProfileTabBarItem1 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Me",@"Me") image:[UIImage imageNamed:@"icon_my_profile_gray"] tag:2];
    myProfileVC.tabBarItem = myProfileTabBarItem1;
	JpNC *myProfileNC = [[JpNC alloc] init];
	[myProfileNC pushViewController:myProfileVC animated:NO];
    [myProfileNC.navigationBar setBarStyle:UIBarStyleBlack];
    
    // More
    ObsdMoreVC *moreVC = [[ObsdMoreVC alloc] init];
    [moreVC setTitle:@"More"];
    UITabBarItem * moreViewTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"More",@"More") image:[UIImage imageNamed:@"icon_more_gray"] tag:4];
    moreVC.tabBarItem = moreViewTabBarItem;
    UINavigationController * moreViewNC = [[UINavigationController alloc] init];
    [moreViewNC pushViewController:moreVC animated:NO];
    [[moreViewNC navigationBar] setTintColor:[UIColor blackColor]];
    
    // Into tabBarController.viewControllers
	self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController setDelegate:self];
    
	self.tabBarController.viewControllers = [NSArray arrayWithObjects: bookingAddNC, bookingHistoryNC, myProfileNC, moreViewNC, nil];
    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bg_tab_black"]];
    
    // First tab:
    UIImageView * greenTab = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    greenTab.center = CGPointMake(42 + 64*0, 19);
    greenTab.image = [UIImage imageNamed:@"icon_booking_add_green"];
    greenTab.tag = 222;
    [self.tabBarController.tabBar addSubview:greenTab];
    [self.tabBarController.tabBar bringSubviewToFront:greenTab];
    [self.tabBarController.tabBar setTintColor:[[JpApplication sharedManager] colorTheme]];
    
}

#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarControllerIn didSelectViewController:(UIViewController *)viewController
{
    // 1st, remove the others
    for (int i=0; i<4; i++) {
        UIViewController * vc = [self.tabBarController.viewControllers objectAtIndex:i];
        
        UITabBarController * tbc = [vc tabBarController];
        UIView * exTab = [tbc.tabBar viewWithTag:222];
        if (exTab) {
            [exTab removeFromSuperview];
            exTab = nil;
        }
    }
    
    // Then, add
    NSArray * tabImages = [NSArray arrayWithObjects: @"icon_booking_add_green", @"icon_booking_history_green", @"icon_my_profile_green", @"icon_more_green", nil];
    NSUInteger index = tabBarControllerIn.selectedIndex;
    UIImageView * greenTab = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    greenTab.center = CGPointMake(40 + 80*index, 19);
    greenTab.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [tabImages objectAtIndex:index]]];
    greenTab.tag = 222;
    [tabBarControllerIn.tabBar addSubview:greenTab];
    [tabBarControllerIn.tabBar bringSubviewToFront:greenTab];
}

@end
