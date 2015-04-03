//
//  BookingTable.m
//  obs
//
//  Created by ganjianping on 5/2/15.
//  Copyright (c) 2015 lt. All rights reserved.
//
#import "ObsBookingTableWithSectionVC.h"
#import "JpDateUtil.h"
#import "ObsBookingTableSectionView.h"
#import "JpUiUtil.h"


@implementation ObsBookingTableWithSectionVC

- (id)init
{
    self = [super init];
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)index
{
    NSString *section = [super.sections objectAtIndex:index];
    NSArray *dataArr = [super.sectionCellsDic objectForKey:section];
    if ([section containsString:@"/"]) {
        NSDate *date = [JpDateUtil getDateFromString:section];
        if ([section containsString:[JpDateUtil getCurrentYearStr]]) {
            section = [JpDateUtil getDateStrWithDate:date dateFormat:@"EEE, dd MMM"];
        } else {
            section = [JpDateUtil getDateStrWithDate:date dateFormat:@"EEE, dd MMM yyyy"];
        }
    }
    
    return [NSString stringWithFormat:@"%@_%lu", section, (unsigned long)[dataArr count]];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ObsBookingTableSectionView * headerView;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        headerView =  [[ObsBookingTableSectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 46.0)];
    else
        headerView =  [[ObsBookingTableSectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 23.0)];
    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    NSString *sectionCount = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    NSArray *sectionCountArr = [sectionCount componentsSeparatedByString:@"_"];
    [headerView setTitle:sectionCountArr[0]];
    [headerView setCount:sectionCountArr[1]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float screenWidth = [JpUiUtil getScreenWidth];
    float height = 90.0;
    if (screenWidth>700) {
        height = 80.0;
    }
    return height;
}

@end