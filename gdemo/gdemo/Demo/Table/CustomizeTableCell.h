//
//  CustomizeTableCell.h
//  gdemo
//
//  Created by ganjianping on 28/2/15.
//  Copyright (c) 2015 ganjp. All rights reserved.
//
#import "JpTableCell.h"

@interface CustomizeTableCell : JpTableCell

@property(nonatomic,strong)UIImageView *leftIV;

@property(nonatomic,strong)UILabel *rightTitleLabel;
@property(nonatomic,strong)UILabel *rightSummaryLabel;

@end
