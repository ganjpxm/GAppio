//
//  ObsBroadcastBookingVC.m
//  obs
//
//  Created by ganjianping on 26/2/15.
//  Copyright (c) 2015 lt. All rights reserved.
//
#import "ObsBookingAlarmListVC.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "ObsWebAPIClient.h"
#import "ObsData.h"
#import "JpUiUtil.h"
#import "JpTableCell.h"
#import "ObsDBManager.h"
#import "JpDataUtil.h"
#import "ObsBookingAlertTableCell.h"
#import "ObsBookingDetailVC.h"
#import "JpConst.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "NSString+Jp.h"
#import "JpDateUtil.h"
#import "JpUtil.h"
#import "ObsTabBC.h"

@interface ObsBookingAlarmListVC ()

@property (readwrite, nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *cellHeights;

@end

@implementation ObsBookingAlarmListVC
{
    BOOL isAcceptBooking;
    NSDictionary *currentObmBookingItem;
}
static NSString *cellIdentifier = @"BookingAlertCell";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.cellHeights = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:SCREEN_BOOKING_BROADCAST];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBookingTableView) name:@"updateBookingTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setCellValue];
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [backButton setTitle:@" Skip" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [self setTitle:@"Broadcast"];
    
    [self reload:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

- (void)reload:(__unused id)sender {
//    if ([[JpDataUtil getValueFromUDByKey:KEY_NETWORK_STATUS] isEqualToString:VALUE_YES]) {
        NSURLSessionTask *task = [ObsWebAPIClient getObmBookingItemsFromServerWithBlock:^(NSArray *sections, NSDictionary *sectionCellsDic, NSError *error) {
            if (!error) {
                NSString *ids = [sectionCellsDic valueForKey:KEY_BROADCAST_BOOKING_VEHICLE_ITEM_IDS];
                if ([ids length]>=32) {
                    [self setCellValue];
                    [self.tableView reloadData];
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[self.cellDics count]];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Thank you for all your broadcast bookings have been accepted or rejected." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alertView.tag = 3;
                    [alertView show];
                }
            }
        }];
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
        [self.refreshControl setRefreshingWithStateOfTask:task];
//    } else {
//        [sender endRefreshing];
//    }
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)setCellValue
{
    ObsDBManager *dbManager = [ObsDBManager getSharedInstance];
    NSString *loginUserId = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID];
    NSMutableArray *obmBookingVehicleItems = [dbManager getObmBookingVehicleItemWithDriverUserId:loginUserId search:SearchBROADCAST];
    self.cellDics = obmBookingVehicleItems;
}
#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float screenWidth = [JpUiUtil getScreenWidth];
    ObsBookingAlertTableCell *bookingAlertCell = (ObsBookingAlertTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (bookingAlertCell == nil) bookingAlertCell = [[ObsBookingAlertTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSDictionary *obmBookingItem = [self.cellDics objectAtIndex:indexPath.row];
    NSMutableAttributedString *htmlAttributedString = [JpUtil getHtmlAttributedString:[self getBookingInfoHtml:obmBookingItem]];
    bookingAlertCell.bookingInfoTV.attributedText = htmlAttributedString;
    
    float height = [JpUtil getRealHeight:htmlAttributedString width:screenWidth-8];
    [bookingAlertCell.bookingInfoTV setFrame:CGRectMake(8, 8, screenWidth-8, height)];
    [bookingAlertCell.acceptBtn setFrame:CGRectMake(8, height-8, 100, 35)];
    
    //[bookingAlertCell.acceptBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    bookingAlertCell.acceptBtn.tag = indexPath.row;
    [bookingAlertCell.acceptBtn addTarget:self action:@selector(acceptBooking:) forControlEvents:UIControlEventTouchUpInside];
    
    [bookingAlertCell.rejectBtn setFrame:CGRectMake(screenWidth-108, height-8, 100, 35)];
    bookingAlertCell.rejectBtn.tag = indexPath.row;
    [bookingAlertCell.rejectBtn addTarget:self action:@selector(rejectBooking:) forControlEvents:UIControlEventTouchUpInside];
    return bookingAlertCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *obmBookingItem = [self.cellDics objectAtIndex:[indexPath row]];
    float height = [JpUtil getRealHeight:[JpUtil getHtmlAttributedString:[self getBookingInfoHtml:obmBookingItem]] width:[JpUiUtil getScreenWidth]-8] + 35;
    return height;
}

- (NSString *)getBookingInfoHtml:(NSDictionary *)obmBookingItem
{
    NSString *bookingInfoHtml;
    NSString *stateCd = [obmBookingItem objectForKey:COLUMN_BOOKING_STATUS_CD];
    if ([VALUE_BOOKING_STATUS_CD_ENQUIREY isEqualToString:stateCd] || [VALUE_BOOKING_STATUS_CD_UNSUCCESSFUL isEqualToString:stateCd] || [VALUE_BOOKING_STATUS_CD_PENDING isEqualToString:stateCd]) {
        bookingInfoHtml = @"<b><big>Customer Enquiry</big></b> <br/> ";
    } else {
        NSString *loginUserId = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID];
        
        if (([obmBookingItem objectForKey:COLUMN_DRIVER_LOGIN_USER_ID] && [loginUserId isEqualToString:[obmBookingItem objectForKey:COLUMN_DRIVER_LOGIN_USER_ID]]) || ([obmBookingItem objectForKey:COLUMN_ASSIGN_DRIVER_USER_ID] && [loginUserId isEqualToString:[obmBookingItem objectForKey:COLUMN_ASSIGN_DRIVER_USER_ID]])) {
            if ([VALUE_BOOKING_STATUS_CD_CANCELLED isEqualToString:stateCd]) {
                bookingInfoHtml = @"<b><big>Cancel Booking</big></b> <br/> ";
            } else {
                bookingInfoHtml = @"<b><big>Booking Update</big></b> <br/> ";
            }
        } else {
            bookingInfoHtml = @"<b><big>New Booking</big></b> <br/> ";
        }
        
    }
    bookingInfoHtml = [NSString stringWithFormat:@"%@ %@ (%@) - ", bookingInfoHtml, [obmBookingItem objectForKey:COLUMN_BOOKING_SERVICE], [obmBookingItem objectForKey:COLUMN_BOOKING_NUMBER]];
    if ([obmBookingItem objectForKey:COLUMN_PAYMENT_MODE] && [[obmBookingItem objectForKey:COLUMN_PAYMENT_MODE] containsString:@"Cash"]) {
         bookingInfoHtml = [NSString stringWithFormat:@"%@ %@", bookingInfoHtml, @"<font color='#ff0000'>cash job</font>"];
    } else {
        bookingInfoHtml = [NSString stringWithFormat:@"%@ %@", bookingInfoHtml, @"<font color='#ff0000'>account job</font>"];
    }
    NSString *pickupDateIntStr = [obmBookingItem objectForKey:COLUMN_PICKUP_DATE_TIME];
    
    bookingInfoHtml = [NSString stringWithFormat:@"%@ <br/>Pick-up : <font color='#ff0000'> %@</font>", bookingInfoHtml, [JpDateUtil getDateTimeStrByMilliSecond:[pickupDateIntStr longLongValue] dateFormate:@"EEE, dd MMM yyyy hh:mm a"]];
    
    NSString *pickupAddress = [obmBookingItem objectForKey:COLUMN_PICKUP_ADDRESS];
    NSString *destinationAddress = [obmBookingItem objectForKey:COLUMN_DESTINATION];
    
    bookingInfoHtml = [NSString stringWithFormat:@"%@ <br/><b>From</b> ", bookingInfoHtml];
    
    NSString *flightNumber = [obmBookingItem objectForKey:COLUMN_FLIGHT_NUMBER];
    NSString *boookingServiceCd = [obmBookingItem objectForKey:COLUMN_BOOKING_SERVICE_CD];
    if ([VALUE_BOOKING_SERVICE_CD_ARRIVAL isEqualToString:boookingServiceCd]) {
        if ([flightNumber length]>1) {
            bookingInfoHtml = [NSString stringWithFormat:@"%@(%@) ", bookingInfoHtml, flightNumber];
        }
    } else if ([VALUE_BOOKING_SERVICE_CD_HOURLY isEqualToString:boookingServiceCd]) {
        bookingInfoHtml = [NSString stringWithFormat:@"%@ (%@ hours) ", bookingInfoHtml, [obmBookingItem objectForKey:COLUMN_BOOKING_HOURS]];
    }
    bookingInfoHtml = [NSString stringWithFormat:@"%@ %@ <b>To</b> ", bookingInfoHtml, pickupAddress];
    if ([VALUE_BOOKING_SERVICE_CD_DEPARTURE isEqualToString:boookingServiceCd]) {
        if ([flightNumber length]>1) {
            bookingInfoHtml = [NSString stringWithFormat:@"%@ (%@ hours) ", bookingInfoHtml, [obmBookingItem objectForKey:COLUMN_BOOKING_HOURS]];
        }
    }
    bookingInfoHtml = [NSString stringWithFormat:@"%@ %@<br/>Vehicle : %@", bookingInfoHtml, destinationAddress, [obmBookingItem objectForKey:COLUMN_VEHICLE]];
    if ([obmBookingItem objectForKey:COLUMN_NUMBER_OF_PASSENGER]) {
        bookingInfoHtml = [NSString stringWithFormat:@"%@ - %@ pax", bookingInfoHtml,  [obmBookingItem objectForKey:COLUMN_NUMBER_OF_PASSENGER]];
    }
    
    NSString *remark = [obmBookingItem objectForKey:COLUMN_REMARK];
    if ([remark length] > 1) {
        bookingInfoHtml = [NSString stringWithFormat:@"%@<br/>Remark : %@", bookingInfoHtml,  [obmBookingItem objectForKey:COLUMN_REMARK]];
    }
    bookingInfoHtml = [NSString stringWithFormat:@"<div style='font-size:20px;'> %@ </div> ", bookingInfoHtml];
    return bookingInfoHtml;
}

- (void)acceptBooking:(id)sender
{
    isAcceptBooking = TRUE;
    
    UIButton *btn = (UIButton *)sender;
    currentObmBookingItem = [self.cellDics objectAtIndex:btn.tag];
    NSString *message = [NSString stringWithFormat:@"Are you confirm that you accept the booking %@ ?", [currentObmBookingItem objectForKey:COLUMN_BOOKING_NUMBER]];
    [self showConfirmDialog:message];
}

- (void)rejectBooking:(id)sender
{
    isAcceptBooking = FALSE;
    UIButton *btn = (UIButton *)sender;
    currentObmBookingItem = [self.cellDics objectAtIndex:btn.tag];
    NSString *message = [NSString stringWithFormat:@"Are you confirm that you reject the booking %@ ?", [currentObmBookingItem objectForKey:COLUMN_BOOKING_NUMBER]];
    [self showConfirmDialog:message];
}

- (void)showConfirmDialog:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Confirm", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"Cancel" pressed
            if (alertView.tag==2) {
                [self reload:nil];
            } else if (alertView.tag==3) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBookingTableView" object:nil];
                [self goHome];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            }
            break;
        case 1: //"Confirm" pressed
            [currentObmBookingItem objectForKey:KEY_BOOKING_VEHICLE_ITEM_ID_OBSD];
            
            NSString *loginUserId = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID];
            NSString *bookingVehicleItemId = [currentObmBookingItem objectForKey:COLUMN_BOOKING_VEHICLE_ITEM_ID];
            NSString *action = [self getAction];
            NSDictionary *parameters = @{KEY_USER_ID:loginUserId, KEY_BOOKING_VEHICLE_ITEM_ID:bookingVehicleItemId, KEY_ACTION:action};
            
            [[ObsWebAPIClient sharedClient] POST:@"/web/responseBroadcastBooking" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                NSMutableDictionary *respondDic = responseObject;
                NSString *result = [respondDic valueForKey:KEY_RESULT];
                if ([result isEqualToString:VALUE_SUCCESS]) {
                   NSString *result = @"Success";
                    if(isAcceptBooking) {
                        result = @"Accept Success";
                    } else {
                        result = @"Reject Success";
                    }
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alertView.tag = 2;
                    [alertView show];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Fail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alertView.tag = 2;
                    [alertView show];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Fail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alertView.tag = 2;
                [alertView show];
            }];
            break;
    }
}

- (NSString *)getAction
{
    NSString *action = @"";
    NSString *loginUserId = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID];
    NSString *stateCd = [currentObmBookingItem objectForKey:COLUMN_BOOKING_STATUS_CD];
    if ([VALUE_BOOKING_STATUS_CD_ENQUIREY isEqualToString:stateCd] || [VALUE_BOOKING_STATUS_CD_UNSUCCESSFUL isEqualToString:stateCd] || [VALUE_BOOKING_STATUS_CD_PENDING isEqualToString:stateCd]) {
        if (isAcceptBooking) {
            action = ACTION_ACCEPT_ENQUIRY_BOOKING;
        } else {
            action = ACTION_REJECT_ENQUIRY_BOOKING;
        }
    } else {
        if (([currentObmBookingItem objectForKey:COLUMN_DRIVER_LOGIN_USER_ID] && [loginUserId isEqualToString:[currentObmBookingItem objectForKey:COLUMN_DRIVER_LOGIN_USER_ID]]) || ([currentObmBookingItem objectForKey:COLUMN_ASSIGN_DRIVER_USER_ID] && [loginUserId isEqualToString:[currentObmBookingItem objectForKey:COLUMN_ASSIGN_DRIVER_USER_ID]])) {
            if ([VALUE_BOOKING_STATUS_CD_CANCELLED isEqualToString:stateCd]) {
                if (isAcceptBooking) {
                    action = ACTION_ACCEPT_CANCEL_BOOKING;
                } else {
                    action = ACTION_REJECT_CANCEL_BOOKING;
                }
            } else {
                if (isAcceptBooking) {
                    action = ACTION_ACCEPT_UPDATE_BOOKING;
                } else {
                    action = ACTION_REJECT_UPDATE_BOOKING;
                }
            }
        } else {
            if (isAcceptBooking) {
                action = ACTION_ACCEPT_NEW_BOOKING;
            } else {
                action = ACTION_REJECT_NEW_BOOKING;
            }
        }
    }
    return action;
}

- (void)updateBookingTableView
{
    [self setCellValue];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (IBAction)onClickBackBtn:(id)sender
{
    [self goHome];
    
}

- (void) goHome
{
    [self.navigationController popViewControllerAnimated:YES];
    NSString *parentVC = NSStringFromClass([[((UINavigationController *)self.parentViewController) visibleViewController] class]);
    if (![parentVC isEqual:@"ObsUpcomingBookingVC"]) {
        [JpDataUtil saveDataToUDForKey:KEY_IS_SHOW_BROADCAST value:VALUE_NO];
        ObsTabBC *obsdTabBC = [[ObsTabBC alloc] init];
        [[[[UIApplication sharedApplication] delegate] window] setRootViewController:obsdTabBC];
    } else {
        [JpDataUtil saveDataToUDForKey:KEY_IS_SHOW_BROADCAST value:VALUE_YES];
    }
}

@end