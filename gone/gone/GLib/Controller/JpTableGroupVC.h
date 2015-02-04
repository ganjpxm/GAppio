//
//  JpTableVC.h
//  JpLib
//
//  Created by Johnny on 30/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

#import "JpTableCell.h"

@interface JpTableGroupVC : UITableViewController

@property (nonatomic,strong) NSMutableArray *sections;
@property (nonatomic,strong) NSMutableDictionary *sectionCellsDic;

- (JpTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
