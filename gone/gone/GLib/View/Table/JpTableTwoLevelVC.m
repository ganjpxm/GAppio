//
//  JpTableTwoLevelVC.m
//  JOne
//
//  Created by Johnny on 30/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

#import "JpTableTwoLevelVC.h"
#import "JpTableSectionView.h"
#import "JpTableCell.h"
#import "JpNC.h"
#import "NSString+Jp.h"
#import "JpDateUtil.h"
#import "JpSystemUtil.h"
@implementation JpTableTwoLevelVC

@synthesize sectionCellsDic,sections;

- (id)init
{
    self = [super init];
    if (self) {
        self.sections = [[NSMutableArray alloc]init];
        self.sectionCellsDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [JpSystemUtil setNavAndStatusbarStytle:self];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%@", self.sections);
    return [self.sections count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)index
{
    NSString *sectionName = [self.sections objectAtIndex:index];
    NSMutableArray *obmBookingItems= [self.sectionCellsDic objectForKey:sectionName];
    return [obmBookingItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) cell = [[JpTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)index
{
    NSString *section = [sections objectAtIndex:index];
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
    JpTableSectionView * headerView;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        headerView =  [[JpTableSectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 46.0)];
    else
        headerView =  [[JpTableSectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 23.0)];
    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView setTitle:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        return 46.0;
    else
        return 23.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

#pragma mark - Table view delegate
// MM_DRAER_SECTION_CELL_DIC @{@"NEW CENTER VIEW":@"Quick View Change,Full View Change", @"DRAWER WIDTH":@"Width 240,Width 320", @"SETTINGS":@"Show Shadow,Pan Center View Open,Pan Center View Close,Tap Center View Close,Pan Drawer View Close,Tap Nav Bar Close,Strech Drawer"};
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *sectionName = [sections objectAtIndex:indexPath.section];
//    NSMutableArray *cellNames = [[NSMutableArray alloc] initWithArray:[[sectionCellsDic objectForKey:sectionName] componentsSeparatedByString:@","]];
//    NSString *cellName = [cellNames objectAtIndex:indexPath.row];

    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
