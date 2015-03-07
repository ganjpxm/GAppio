//
//  ObsBookingAlertTableCell.m
//  JOne
//
//  Created by Johnny on 30/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

#import "ObsBookingAlertTableCell.h"
#import "JpApplication.h"
#import "JpUiUtil.h"
#import "JpConst.h"

@implementation ObsBookingAlertTableCell

@synthesize bookingInfoTV,acceptBtn,rejectBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bookingInfoTV = [[UILabel alloc] init];
        bookingInfoTV.lineBreakMode = NSLineBreakByWordWrapping;
        bookingInfoTV.numberOfLines = 0;
        [bookingInfoTV setTextColor:[UIColor blackColor]];
        [bookingInfoTV setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
        [bookingInfoTV sizeToFit];
        [self addSubview:bookingInfoTV];
        
        acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [acceptBtn setTitle:@"Accept" forState:UIControlStateNormal];
        [acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [acceptBtn setBackgroundColor:COLOR_BLACK_JP];
        [acceptBtn setBackgroundImage:[JpUiUtil imageWithColor:COLOR_GRAY_DARK_PRIMARY] forState:UIControlStateHighlighted];
        acceptBtn.layer.cornerRadius = 4;
        acceptBtn.clipsToBounds = YES;
        [self addSubview:acceptBtn];
        
        rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rejectBtn setTitle:@"Reject" forState:UIControlStateNormal];
        [rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rejectBtn setBackgroundColor:COLOR_BLACK_JP];
        [rejectBtn setBackgroundImage:[JpUiUtil imageWithColor:COLOR_GRAY_DARK_PRIMARY] forState:UIControlStateHighlighted];
        rejectBtn.layer.cornerRadius = 4;
        rejectBtn.clipsToBounds = YES;
        [self addSubview:rejectBtn];
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
