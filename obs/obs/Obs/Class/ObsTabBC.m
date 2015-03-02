//
//  ObsTabBC.m
//  obs
//
//  Created by Johnny on 11/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "ObsTabBC.h"
#import "ObsHistoryBookingVC.h"
#import "JpNC.h"
#import "ObsUpcomingBookingVC.h"
#import "ObsMoreVC.h"
#import "ObsMyProfileVC.h"
#import "JpApplication.h"
#import "JpUiUtil.h"

@interface ObsTabBC ()

@property (nonatomic, retain) IBOutlet UITabBarController *mTabBarController;

@end

@implementation ObsTabBC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Configure tab and Nav controllers and lay it on window
	[self configureTabsAndNavigationControllers];
    [self.view addSubview:self.mTabBarController.view];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void) configureTabsAndNavigationControllers {
    // Home
	ObsUpcomingBookingVC *upcomingBookingVC = [[ObsUpcomingBookingVC alloc] init];
    [upcomingBookingVC setTitle:@"Upcoming Booking"];
	UITabBarItem *upcomingBookingTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Upcoming",@"Upcoming") image:[UIImage imageNamed:@"icon_add_gray"] tag:0];
    upcomingBookingVC.tabBarItem = upcomingBookingTabBarItem;
	JpNC *upcomingBookingNC = [[JpNC alloc] init];
	[upcomingBookingNC pushViewController:upcomingBookingVC animated:NO];
    [upcomingBookingNC.navigationBar setBarStyle:UIBarStyleBlack];
    
    ObsHistoryBookingVC * bookingHistoryVC = [[ObsHistoryBookingVC alloc] init];
    [bookingHistoryVC setTitle:@"History Booking"];
    UITabBarItem *bookingHistoryTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"History",@"History") image:[UIImage imageNamed:@"icon_history_gray"] tag:1];
    bookingHistoryVC.tabBarItem = bookingHistoryTabBarItem;
    JpNC *historyBookingNC = [[JpNC alloc] init];
    [historyBookingNC pushViewController:bookingHistoryVC animated:NO];
    [[historyBookingNC navigationBar] setTintColor:[UIColor blackColor]];
    
    ObsMyProfileVC *myProfileVC = [[ObsMyProfileVC alloc] init];
    [myProfileVC setTitle:@"My Profile"];
	UITabBarItem *myProfileTabBarItem1 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Me",@"Me") image:[UIImage imageNamed:@"icon_me_gray"] tag:2];
    myProfileVC.tabBarItem = myProfileTabBarItem1;
	JpNC *myProfileNC = [[JpNC alloc] init];
	[myProfileNC pushViewController:myProfileVC animated:NO];
    [myProfileNC.navigationBar setBarStyle:UIBarStyleBlack];
    
    // More
    ObsMoreVC *moreVC = [[ObsMoreVC alloc] init];
    [moreVC setTitle:@"More"];
    UITabBarItem * moreViewTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"More",@"More") image:[UIImage imageNamed:@"icon_more_gray"] tag:4];
    moreVC.tabBarItem = moreViewTabBarItem;
    UINavigationController * moreViewNC = [[UINavigationController alloc] init];
    [moreViewNC pushViewController:moreVC animated:NO];
    [[moreViewNC navigationBar] setTintColor:[UIColor blackColor]];
    
    // Into tabBarController.viewControllers
	self.mTabBarController = [[UITabBarController alloc] init];
    [self.mTabBarController setDelegate:self];
    
	self.mTabBarController.viewControllers = [NSArray arrayWithObjects: upcomingBookingNC, historyBookingNC, myProfileNC, moreViewNC, nil];
    [self.mTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bg_tab_black"]];
    
    // First tab:
    UIImageView * firstTabImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    firstTabImageView.center = CGPointMake(42, 19);
    firstTabImageView.tag = 222;
    [self.mTabBarController.tabBar addSubview:firstTabImageView];
    [self.mTabBarController.tabBar bringSubviewToFront:firstTabImageView];
    [self.mTabBarController.tabBar setTintColor:[JpApplication sharedManager].colorFront];
}

#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarControllerIn didSelectViewController:(UIViewController *)viewController
{
    // 1st, remove the others
    for (int i=0; i<4; i++) {
        UIViewController * vc = [self.mTabBarController.viewControllers objectAtIndex:i];
        
        UITabBarController * tbc = [vc tabBarController];
        UIView * exTab = [tbc.tabBar viewWithTag:222];
        if (exTab) {
            [exTab removeFromSuperview];
            exTab = nil;
        }
    }
    
    // Then, add
    NSUInteger index = tabBarControllerIn.selectedIndex;
    UIImageView * tabImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    tabImageView.center = CGPointMake(42 + ([JpUiUtil getScreenWidth]/4)*index, 19);
    tabImageView.tag = 222;
    [tabBarControllerIn.tabBar addSubview:tabImageView];
    [tabBarControllerIn.tabBar bringSubviewToFront:tabImageView];
}

@end
