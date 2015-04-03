//
//  ObsHistoryBookingVC.m
//  obs
//
//  Created by Johnny on 14/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "ObsHistoryBookingVC.h"
#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "ObsWebAPIClient.h"
#import "ObsData.h"
#import "JpUiUtil.h"
#import "JpTableSectionView.h"
#import "JpTableCell.h"
#import "ObsDBManager.h"
#import "JpDateUtil.h"
#import "JpDataUtil.h"
#import "ObsBookingListTableCell.h"
#import "ObsHistoryBookingDetailVC.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "JpConst.h"

@interface ObsHistoryBookingVC ()

@property (readwrite, nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ObsHistoryBookingVC

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:SCREEN_BOOKING_PAST];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)reload:(__unused id)sender {
    if ([[JpDataUtil getValueFromUDByKey:KEY_NETWORK_STATUS] isEqualToString:VALUE_YES]) {
        NSURLSessionTask *task = [ObsWebAPIClient getObmBookingItemsFromServerWithBlock:^(NSArray *sections, NSDictionary *sectionCellsDic, NSError *error) {
            if (!error) {
                if ([sections count]>0) {
                    [self setSectionAndCellValue];
                    [self.tableView reloadData];
                }
            }
        }];
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
        [self.refreshControl setRefreshingWithStateOfTask:task];
    } else {
        [sender endRefreshing];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBookingTableView) name:@"updateBookingTableView" object:nil];
    self.tableView.rowHeight = 70.0f;
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self setSectionAndCellValue];
}

- (void)setSectionAndCellValue
{
    ObsDBManager *dbManager = [ObsDBManager getSharedInstance];
    NSString *loginUserId = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID];
    NSMutableArray *obmBookingVehicleItems = [dbManager getObmBookingVehicleItemWithDriverUserId:loginUserId search:SearchPAST];
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
    if ([obmBookingVehicleItems count]>300) {
        NSString *loginUserId = [JpDataUtil getValueFromUDByKey:KEY_OBS_USER_ID];
        NSString *lastUpdateTimeKey = [loginUserId stringByAppendingString:TABLE_OBM_BOOKING_VEHICLE_ITEM];
        [JpDataUtil saveDataToUDForKey:lastUpdateTimeKey value:nil];
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ObsBookingListTableCell *cell = (ObsBookingListTableCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) cell = [[ObsBookingListTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    NSString *sectionName = [self.sections objectAtIndex:indexPath.section];
    NSMutableArray *obmBookingItems= [self.sectionCellsDic objectForKey:sectionName];
    NSDictionary *obmBookingItem = [obmBookingItems objectAtIndex:indexPath.row];
    
    NSString *pickupTime = [obmBookingItem objectForKey:COLUMN_PICKUP_TIME];
    if (pickupTime && [pickupTime length]>5) {
        pickupTime= [pickupTime substringWithRange:NSMakeRange(0, 5)];
    }
    cell.leftTopTV.text = pickupTime;
    
    NSString *paymentMode = [obmBookingItem objectForKey:COLUMN_PAYMENT_MODE];
    if (paymentMode && [paymentMode isEqualToString:@"Cash" ]) {
        [cell.leftBottomTV setTextColor:[UIColor redColor]];
        cell.leftBottomTV.text = [NSString stringWithFormat:@"%@ %@ \nCash", [obmBookingItem objectForKey:COLUMN_PRICE_UNIT], [obmBookingItem objectForKey:COLUMN_PRICE]];
    } else {
        NSString *paymentStatus = [obmBookingItem objectForKey:COLUMN_PAYMENT_STATUS];
        if (paymentStatus) {
            if (paymentMode && [paymentMode isEqualToString:@"Invoice" ]) {
                [cell.leftBottomTV setTextColor:[UIColor redColor]];
                cell.leftBottomTV.text = [NSString stringWithFormat:@"%@\nInvoice", paymentStatus];
            } else {
                cell.leftBottomTV.text = paymentStatus;
                if ([paymentStatus isEqualToString:@"Paid" ]) {
                    [cell.leftBottomTV setTextColor:[UIColor blackColor]];
                } else {
                    [cell.leftBottomTV setTextColor:[UIColor redColor]];
                }
            }
        }
    }
    
    NSString *remark = [obmBookingItem objectForKey:COLUMN_REMARK];
    if (remark && [remark length]>1 && ![@"<null>" isEqualToString:remark]) {
        cell.commentIV.hidden = NO;
    } else {
        cell.commentIV.hidden = YES;
    }
    
    NSString *stop1Address = [obmBookingItem objectForKey:COLUMN_STOP1_ADDRESS];
    if (stop1Address && [stop1Address length]>1 && ![@"<null>" isEqualToString:stop1Address]) {
        cell.stopIV.hidden = NO;
        if (!(remark && [remark length]>1 && ![@"<null>" isEqualToString:remark])) {
            CGRect oldFrame = cell.stopIV.frame;
            CGRect newFrame = CGRectMake([JpUiUtil getScreenWidth]-24, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
            cell.stopIV.frame = newFrame;
        } else {
            CGRect oldFrame = cell.stopIV.frame;
            cell.stopIV.frame = CGRectMake([JpUiUtil getScreenWidth]-45, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
        }
    } else {
        cell.stopIV.hidden = YES;
    }
    
    NSString *bookingServiceCd = [obmBookingItem objectForKey:COLUMN_BOOKING_SERVICE_CD];
    NSString *bookingService = [obmBookingItem objectForKey:COLUMN_BOOKING_SERVICE];
    if ([VALUE_BOOKING_SERVICE_CD_ARRIVAL isEqualToString:bookingServiceCd]) {
        bookingService = @"Arr";
    } else if ([VALUE_BOOKING_SERVICE_CD_DEPARTURE isEqualToString:bookingServiceCd]) {
        bookingService = @"Dep";
    } else if ([VALUE_BOOKING_SERVICE_CD_POINT_TO_POINT isEqualToString:bookingServiceCd]) {
        bookingService = @"PTP";
    } else if ([VALUE_BOOKING_SERVICE_CD_HOURLY isEqualToString:bookingServiceCd]) {
        bookingService = @"HD";
    }
    
    NSString *firstLineHtml = [NSString stringWithFormat:@"<div style='font-size:18px;'>%@ <span style='color:gray;'>- %@</span>", [obmBookingItem objectForKey:COLUMN_BOOKING_NUMBER], bookingService];
    NSString *driverClaimPrice = [obmBookingItem objectForKey:COLUMN_DRIVER_CLAIM_PRICE];
    if ([driverClaimPrice length]>0 && ![@"0.0" isEqualToString:driverClaimPrice]) {
        NSString *driverClaimStatus = [obmBookingItem objectForKey:COLUMN_DRIVER_CLAIM_STATUS];
        NSString *currency = [obmBookingItem objectForKey:COLUMN_DRIVER_CLAIM_CURRENCY];
        if ([@"SGD" isEqualToString:currency]) {
            currency = @"S$";
        } else if ([@"MYR" isEqualToString:currency]) {
            currency = @"RM";
        }
        if ([@"Paid" isEqualToString:driverClaimStatus]) {
            firstLineHtml = [NSString stringWithFormat:@"%@ <span>%@%@</span>", firstLineHtml,currency,driverClaimPrice];
        } else {
            firstLineHtml = [NSString stringWithFormat:@"%@ <span style='color:red'>%@%@</span>", firstLineHtml,currency,driverClaimPrice];
        }
    }
    firstLineHtml = [NSString stringWithFormat:@"%@</div>", firstLineHtml];
    NSAttributedString *firstLineAS = [[NSAttributedString alloc] initWithData:[firstLineHtml dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    cell.rightTopTV.attributedText = firstLineAS;
    
    NSString *pickupAddress = [obmBookingItem objectForKey:COLUMN_PICKUP_ADDRESS];
    NSString *flightNumber = [obmBookingItem objectForKey:COLUMN_FLIGHT_NUMBER];
    NSString *serviceCd = [obmBookingItem objectForKey:COLUMN_BOOKING_SERVICE_CD];
    NSString *destinationAddress = [obmBookingItem objectForKey:COLUMN_DESTINATION];
    NSString *htmlString = @"<div style='font-size:18px;'><span style='font-weight:bold;'>";
    if ([serviceCd length]>0 && [VALUE_BOOKING_SERVICE_CD_ARRIVAL isEqualToString:serviceCd] && [flightNumber length]>1 && ![@"<null>" isEqualToString:flightNumber]) {
        pickupAddress = [NSString stringWithFormat:@"(%@) %@ ", flightNumber, pickupAddress];
    } else if ([serviceCd length]>0 && [VALUE_BOOKING_SERVICE_CD_HOURLY isEqualToString:serviceCd]) {
        pickupAddress = [NSString stringWithFormat:@"(%@ hours) %@ ", [obmBookingItem objectForKey:COLUMN_BOOKING_HOURS], pickupAddress];
    }
    htmlString = [NSString stringWithFormat:@"%@%@<span> to ", htmlString, pickupAddress];
    if ([serviceCd length]>0 && [VALUE_BOOKING_SERVICE_CD_DEPARTURE isEqualToString:serviceCd] && [flightNumber length]>1 && ![@"<null>" isEqualToString:flightNumber]) {
        destinationAddress = [NSString stringWithFormat:@"(%@) %@ ", [obmBookingItem objectForKey:COLUMN_FLIGHT_NUMBER], destinationAddress];
    }
    htmlString = [NSString stringWithFormat:@"%@%@ </div>", htmlString, destinationAddress];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    cell.rightMiddleTV.attributedText = attributedString;
    cell.rightBottomTV.text = [NSString stringWithFormat:@"%@ - %@", [obmBookingItem objectForKey:COLUMN_BOOKING_STATUS], [obmBookingItem objectForKey:COLUMN_DRIVER_USER_NAME]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSString *sectionName = [self.sections objectAtIndex:indexPath.section];
    NSMutableArray *obmBookingItems= [self.sectionCellsDic objectForKey:sectionName];
    NSDictionary *obmBookingItem = [obmBookingItems objectAtIndex:indexPath.row];
    
    ObsHistoryBookingDetailVC *bookingVehicleDetailVC = [[ObsHistoryBookingDetailVC alloc] init:@"Past" data:obmBookingItem];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    bookingVehicleDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bookingVehicleDetailVC  animated:NO];
}

- (void)updateBookingTableView
{
    [self setSectionAndCellValue];
    [self.tableView reloadData];
}

@end
