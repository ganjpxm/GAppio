//
//  BookingTable.m
//  obs
//
//  Created by ganjianping on 5/2/15.
//  Copyright (c) 2015 lt. All rights reserved.
//
#import "BookingTableVC.h"
#import "JpDateUtil.h"
#import "BookingTableSectionView.h"
#import "JpUiUtil.h"


@implementation BookingTableVC

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
    if ([section containsString:@"/"]) {
        NSDate *date = [JpDateUtil getDateFromString:section];
        if ([section containsString:[JpDateUtil getCurrentYearStr]]) {
            section = [JpDateUtil getDateStrWithDate:date dateFormat:@"EEE, dd MMM"];
        } else {
            section = [JpDateUtil getDateStrWithDate:date dateFormat:@"EEE, dd MMM yyyy"];
        }
    }
    return section;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BookingTableSectionView * headerView;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        headerView =  [[BookingTableSectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 46.0)];
    else
        headerView =  [[BookingTableSectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 23.0)];
    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView setTitle:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
    
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