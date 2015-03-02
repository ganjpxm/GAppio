//
//  CustomizeTableVC.m
//  gdemo
//
//  Created by ganjianping on 28/2/15.
//  Copyright (c) 2015 ganjp. All rights reserved.
//

#import "CustomizeTableVC.h"
#import "JpTableCell.h"

@interface CustomizeTableVC ()

@end

@implementation CustomizeTableVC

- (id)init
{
    self = [super init];
    [super initWithTextArr:[NSArray arrayWithObjects:@"iOS", @"Android", @"Window Phone", @"BlackBerry", @"Firefox OS", @"Sailfish OS", @"Tizen", @"Ubuntu Touch OS", @"Symbian", @"Windows Mobile", @"Palm OS", @"webOS", @"Maemo", @"MeeGo", @"LiMo", nil]];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize table data
}

//- (JpTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    static NSString *cellIdentifier = @"Cell";
//    JpTableCell *cell = (JpTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) cell = [[JpTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//    
//    NSDictionary *cellDic = [self.cellDics objectAtIndex:indexPath.row];
//    cell.textLabel.text = [cellDic objectForKey:@"text"];
//    return cell;
//}


@end