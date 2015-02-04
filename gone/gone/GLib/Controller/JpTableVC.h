//
//  JpTableVC.h
//  JpLib
//
//  Created by Johnny on 30/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

@interface JpTableVC : UITableViewController

@property (nonatomic,strong) NSMutableArray *cellDics;

- (void)initWithTextArr:(NSArray *)textArr;

@end
