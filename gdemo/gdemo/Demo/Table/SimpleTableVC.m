//
//  SimpleTableViewController.m
//  SimpleTable
//
//  Created by Simon on 1/12/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SimpleTableVC.h"
#import "UIAlertView+Jp.h"

@interface SimpleTableVC ()

@end

@implementation SimpleTableVC
{
    NSArray *mobileOSs;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Initialize table data
    mobileOSs = [NSArray arrayWithObjects:@"iOS", @"Android", @"Window Phone", @"BlackBerry", @"Firefox OS", @"Sailfish OS", @"Tizen", @"Ubuntu Touch OS", @"Symbian", @"Windows Mobile", @"Palm OS", @"webOS", @"Maemo", @"MeeGo", @"LiMo", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------- UITableView methods --------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mobileOSs count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [mobileOSs objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"ic_mobile"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIAlertView showAlertWithTitle:@"" message:[mobileOSs objectAtIndex:indexPath.row]];
}


@end
