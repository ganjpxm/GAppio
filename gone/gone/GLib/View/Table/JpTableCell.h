//
//  MMTableCell.m
//  JpLib
//
//  Created by Johnny on 30/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

@interface JpTableCell : UITableViewCell

@property (nonatomic, strong) UIColor * accessoryCheckmarkColor;
@property (nonatomic, strong) UIColor * disclosureIndicatorColor;

- (void)updateContentForNewContentSize;

@end
