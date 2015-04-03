//
//  CustomizeTableCell.m
//  gdemo
//
//  Created by ganjianping on 28/2/15.
//  Copyright (c) 2015 ganjp. All rights reserved.
//

#import "CustomizeTableCell.h"
#import "JpUiUtil.h"
#import "JpApplication.h"

@interface CustomizeTableCell ()

@end

@implementation CustomizeTableCell

@synthesize leftIV,rightTitleLabel,rightSummaryLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float screenWidth = [JpUiUtil getScreenWidth];
        UIColor *colorTheme = [[JpApplication sharedManager] colorPrimary];
        float imageWidth = 32;
        float imageHeight = 32;
        float pageMargin = 16;
        float textPadding = 8;
        
        leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(pageMargin, textPadding, imageWidth, imageHeight)];
        [leftIV setImage:[UIImage imageNamed:@"ic_mobile"]];
        [leftIV setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:leftIV];
        
        float rightX = pageMargin + imageWidth + textPadding;
        rightTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(rightX, textPadding, screenWidth-rightX-pageMargin, 20)];
        rightTitleLabel.numberOfLines = 1;
        rightTitleLabel.font=[rightTitleLabel.font fontWithSize:18];
        [self addSubview:rightTitleLabel];
        
        rightSummaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(rightX, textPadding+20+4, screenWidth-rightX-pageMargin, 20)];
        rightSummaryLabel.numberOfLines = 1;
        rightSummaryLabel.font=[rightTitleLabel.font fontWithSize:14];
        [self addSubview:rightTitleLabel];
    }
    return self;
}


@end