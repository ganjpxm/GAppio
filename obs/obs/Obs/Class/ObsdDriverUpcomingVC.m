//
//  ObsdDriverUpcomingVC.m
//  obsd
//
//  Created by Johnny on 20/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "ObsdDriverUpcomingVC.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "ObsWebAPIClient.h"
#import "ObsdData.h"
#import "JpUiUtil.h"
#import "JpTableSectionView.h"
#import "JpTableCell.h"
#import "DBManager.h"
#import "JpDateUtil.h"
#import "JpDataUtil.h"
#import "ObsdBookingVehicleTableCell.h"
#import "ObsdBookingVehicleDetailVC.h"
#import "JpConst.h"


@interface ObsdDriverUpcomingVC ()

@property (readwrite, nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ObsdDriverUpcomingVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //SCREEN_BOOKING_UPCONMING
}

- (void)reload:(__unused id)sender {
    if ([[JpDataUtil getValueFromUDByKey:KEY_NETWORK_STATUS_OBSD] isEqualToString:VALUE_YES]) {
    NSURLSessionTask *task = [ObsWebAPIClient getObmBookingItemsFromServerWithBlock:^(NSArray *sections, NSDictionary *sectionCellsDic, NSError *error) {
        if (!error) {
            if ([self.sectionCellsDic count]==0) {
                [self setSectionAndCellValue];
            } else {
                if ([sections count]>0 && ![self.sections containsObject:VALUE_NEW_ITEMS]) {
                    [self.sections insertObject:VALUE_NEW_ITEMS atIndex:0];
                }
                if ((!sectionCellsDic || [sectionCellsDic count]==0) && [self.sections containsObject:VALUE_NEW_ITEMS]) {
                     [self setSectionAndCellValue];
                }
                for (NSString *key in [sectionCellsDic allKeys]) {
                    NSArray *webObmBookingVehicleItems = [sectionCellsDic objectForKey:key];
                    if ([self.sectionCellsDic objectForKey:VALUE_NEW_ITEMS]) {
                        NSMutableArray *newItemObmBookingVehicleItems = [self.sectionCellsDic objectForKey:VALUE_NEW_ITEMS];
                        for (NSDictionary *webObmBookingVehicleItem in webObmBookingVehicleItems) {
                            [newItemObmBookingVehicleItems addObject:webObmBookingVehicleItem];
                        }
                        [self.sectionCellsDic setValue:newItemObmBookingVehicleItems forKey:VALUE_NEW_ITEMS];
                    } else {
                        [self.sectionCellsDic setValue:webObmBookingVehicleItems forKey:VALUE_NEW_ITEMS];
                    }
                }
            }
            [self.tableView reloadData];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl setRefreshingWithStateOfTask:task];
        
    } else {
        [sender endRefreshing];
    }
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBookingTableView) name:@"updateBookingTableView" object:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70.0f;
    
    [self setSectionAndCellValue];
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    
    [self reload:nil];
}

- (void)setSectionAndCellValue
{
    DBManager *dbManager = [DBManager getSharedInstance];
    NSString *loginUserId = [JpDataUtil getValueFromUDByKey:KEY_USER_ID_OBSD];
    NSMutableArray *obmBookingVehicleItems = [dbManager getObmBookingVehicleItemWithDriverUserId:loginUserId search:SearchUPCOMING];
    self.sections = [[NSMutableArray alloc]init];
    self.sectionCellsDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *attributes in obmBookingVehicleItems) {
        NSString *pickupDateIntStr = [attributes objectForKey:COLUMN_PICKUP_DATE];
        if (pickupDateIntStr != nil && ![pickupDateIntStr isKindOfClass:[NSNull class]]) {
            NSString *pickupDateStr = [JpDateUtil getDateStrByMilliSecond:[pickupDateIntStr longLongValue]];
            
            if (![self.sections containsObject:pickupDateStr]) {
                [self.sections addObject:pickupDateStr];
            }
            if ([self.sectionCellsDic objectForKey:pickupDateStr]) {
                [[self.sectionCellsDic objectForKey:pickupDateStr] addObject:attributes];
            } else {
                NSMutableArray *newObmBookingItems = [[NSMutableArray alloc]init];
                [newObmBookingItems addObject:attributes];
                [self.sectionCellsDic setObject:newObmBookingItems forKey:pickupDateStr];
            }
        }
    }
}
#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ObsdBookingVehicleTableCell *cell = (ObsdBookingVehicleTableCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) cell = [[ObsdBookingVehicleTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    NSString *sectionName = [self.sections objectAtIndex:indexPath.section];
    NSMutableArray *obmBookingItems= [self.sectionCellsDic objectForKey:sectionName];
    NSDictionary *obmBookingItem = [obmBookingItems objectAtIndex:indexPath.row];

    NSString *pickupTime = [obmBookingItem objectForKey:COLUMN_PICKUP_TIME];
    NSString *paymentStatus = [obmBookingItem objectForKey:COLUMN_PAYMENT_STATUS];
    if (pickupTime && [pickupTime length]>5) {
       pickupTime= [pickupTime substringWithRange:NSMakeRange(0, 5)];
    }
    cell.leftTopTV.text = pickupTime;
    
    if (paymentStatus && [paymentStatus length]>2 && ![paymentStatus isEqualToString:@"<null>"]) {
        if (![paymentStatus isEqualToString:@"Paid"]) {
            [cell.leftBottomTV setTextColor:[UIColor redColor]];
        } else {
            [cell.leftBottomTV setTextColor:COLOR_GREEN_JP];
        }
        cell.leftBottomTV.text = paymentStatus;
    }
    
    
    cell.rightTopTV.text = [obmBookingItem objectForKey:COLUMN_BOOKING_NUMBER];
    NSString *pickupAddress = [obmBookingItem objectForKey:COLUMN_PICKUP_ADDRESS];
    NSString *destinationAddress = [obmBookingItem objectForKey:COLUMN_DESTINATION];
    NSString *htmlString = [NSString stringWithFormat:@"<div style='font-size:15px;'><span style='font-weight:bold;'>%@</span> to %@ </div>", pickupAddress, destinationAddress];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    cell.rightMiddleTV.attributedText = attributedString;
    cell.rightBottomTV.text = [obmBookingItem objectForKey:COLUMN_BOOKING_STATUS];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSString *sectionName = [self.sections objectAtIndex:indexPath.section];
    NSMutableArray *obmBookingItems= [self.sectionCellsDic objectForKey:sectionName];
    NSDictionary *obmBookingItem = [obmBookingItems objectAtIndex:indexPath.row];
    
    ObsdBookingVehicleDetailVC *bookingVehicleDetailVC = [[ObsdBookingVehicleDetailVC alloc] init:@"Upcoming" data:obmBookingItem];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    bookingVehicleDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bookingVehicleDetailVC  animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JpTableSectionView * headerView;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        headerView =  [[JpTableSectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 46.0)];
    else
        headerView =  [[JpTableSectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 23.0)];
    headerView.label.font = [UIFont boldSystemFontOfSize:16];
    headerView.label.textColor = [UIColor blackColor];
    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView setTitle:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
    return headerView;
}

- (void)updateBookingTableView
{
    [self setSectionAndCellValue];
    [self.tableView reloadData];
}

@end
