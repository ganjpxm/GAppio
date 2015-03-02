//
//  MMSideDrawerTableViewCell.m
//  JOne
//
//  Created by Johnny on 30/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

#import "ObsBookingTableCell.h"
#import "JpApplication.h"
#import "JpUiUtil.h"

@implementation ObsBookingTableCell

@synthesize leftTopTV,leftBottomTV,middleView,rightTopTV,rightMiddleTV,rightBottomTV,commentIV,stopIV;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float screenWidth = [JpUiUtil getScreenWidth];
        UIColor *colorTheme = [[JpApplication sharedManager] colorPrimary];
        float leftY = 25;
        float middleHeight = 70;
        if (screenWidth>700) {
            leftY = 20;
            middleHeight = 60;
        }
        leftTopTV = [[UILabel alloc]initWithFrame:CGRectMake(10,leftY,60,20)];
        leftTopTV.numberOfLines = 1;
        [leftTopTV setTextColor:[UIColor blackColor]];
        [leftTopTV setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
        [self addSubview:leftTopTV];
        
        leftBottomTV = [[UILabel alloc]initWithFrame:CGRectMake(10,leftY+15,60,40)];
        [leftBottomTV setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
        leftBottomTV.numberOfLines = 2;
        [self addSubview:leftBottomTV];
        
        commentIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-24, 7, 16, 16)];
        [commentIV setImage:[UIImage imageNamed:@"icon_comment_red"]];
        [commentIV setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:commentIV];
        commentIV.hidden = YES;
        
        stopIV = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-45, 7, 16, 16)];
        [stopIV setImage:[UIImage imageNamed:@"icon_stop_red"]];
        [stopIV setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:stopIV];
        stopIV.hidden = YES;
        
        middleView = [[UIView alloc]initWithFrame:CGRectMake(68, 10, 1, middleHeight)];
        [middleView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:middleView];
        
        rightTopTV = [[UILabel alloc]initWithFrame:CGRectMake(80,5,screenWidth-90,20)];
        rightTopTV.numberOfLines = 1;
        rightTopTV.font=[rightTopTV.font fontWithSize:16];
        [self addSubview:rightTopTV];
        
        float rightY = 25;
        float rightMiddleHeight = 40;
        if (screenWidth>700) {
            rightMiddleHeight = 28;
        }
        rightMiddleTV = [[UILabel alloc]initWithFrame:CGRectMake(80,rightY,screenWidth-90,rightMiddleHeight)];
        rightMiddleTV.numberOfLines = 2;
        [rightMiddleTV setLineBreakMode:NSLineBreakByTruncatingTail];
        [self addSubview:rightMiddleTV];
        
        rightBottomTV = [[UILabel alloc]initWithFrame:CGRectMake(80,rightY+rightMiddleHeight-3,screenWidth-90,25)];
        rightBottomTV.numberOfLines = 1;
        rightBottomTV.font=[rightBottomTV.font fontWithSize:14];
        [rightBottomTV setTextColor:[UIColor grayColor]];
        [self addSubview:rightBottomTV];
        
        UIView * backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        UIColor * backgroundColor;
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            backgroundColor = [UIColor whiteColor];
        } else {
            backgroundColor = [UIColor colorWithRed:77.0/255.0 green:79.0/255.0 blue:80.0/255.0 alpha:1.0];
        }
        [backgroundView setBackgroundColor:backgroundColor];
        [self setBackgroundView:backgroundView];
        UIView *selectedView = [[UIView alloc] init];
        selectedView.backgroundColor = [colorTheme colorWithAlphaComponent:0.3f];
        [self setSelectedBackgroundView:selectedView];
        
        [self setAccessoryCheckmarkColor:colorTheme];
    }
    return self;
}

- (void)updateContentForNewContentSize
{
    if ([[UIFont class] respondsToSelector:@selector(preferredFontForTextStyle:)]) {
        [self.textLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    } else {
        [self.textLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    }
}


@end
