//
//  JpTableVC.m
//  JOne
//
//  Created by Johnny on 30/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

#import "JpTableVC.h"
#import "JpTableSectionView.h"
#import "JpTableCell.h"
#import "JpSystemUtil.h"

@implementation JpTableVC

@synthesize cellDics;

- (id)init
{
    self = [super init];
    if (self) {
        self.cellDics = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)initWithTextArr:(NSArray *)textArr
{
    for (NSString *text in textArr) {
        [cellDics addObject:@{@"text":text}];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section
{
    return (NSInteger)[self.cellDics count];
}
- (JpTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    JpTableCell *cell = (JpTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) cell = [[JpTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSDictionary *cellDic = [cellDics objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellDic objectForKey:@"text"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
