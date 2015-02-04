//
//  MMSideDrawerTableViewCell.m
//  JOne
//
//  Created by Johnny on 30/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

#import "ObsdBookingVehicleTableCell.h"
#import "JpApplication.h"

@implementation ObsdBookingVehicleTableCell

@synthesize leftTopTV,leftBottomTV,middleView,rightTopTV,rightMiddleTV,rightBottomTV;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIColor *colorTheme = [[JpApplication sharedManager] colorTheme];
        leftTopTV = [[UILabel alloc]initWithFrame:CGRectMake(7,25,50,20)];
        leftTopTV.numberOfLines = 1;
        [leftTopTV setTextColor:[UIColor blackColor]];
        [leftBottomTV setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
        [self addSubview:leftTopTV];
        
        leftBottomTV = [[UILabel alloc]initWithFrame:CGRectMake(5,30,50,40)];
        [leftBottomTV setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        leftBottomTV.numberOfLines = 1;
        [self addSubview:leftBottomTV];
        
        middleView = [[UIView alloc]initWithFrame:CGRectMake(55, 10, 2, 60)];
        [middleView setBackgroundColor:colorTheme];
        [self addSubview:middleView];
        
        rightTopTV = [[UILabel alloc]initWithFrame:CGRectMake(65,5,245,20)];
        rightTopTV.numberOfLines = 1;
        rightTopTV.font=[rightTopTV.font fontWithSize:14];
        [self addSubview:rightTopTV];
        
        rightMiddleTV = [[UILabel alloc]initWithFrame:CGRectMake(65,20,245,40)];
        rightMiddleTV.numberOfLines = 2;
        [rightMiddleTV setLineBreakMode:NSLineBreakByTruncatingTail];
        [self addSubview:rightMiddleTV];
        
        rightBottomTV = [[UILabel alloc]initWithFrame:CGRectMake(65,55,245,20)];
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
