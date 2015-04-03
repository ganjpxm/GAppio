//
//  BookingTableSectionView.m
//  obs
//
//  Created by ganjianping on 5/2/15.
//  Copyright (c) 2015 lt. All rights reserved.
//

#import "ObsBookingTableSectionView.h"
#import "JpUiUtil.h"


@interface ObsBookingTableSectionView ()

@end

@implementation ObsBookingTableSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect myFrame = self.label.frame;
        myFrame.origin = CGPointMake(32, myFrame.origin.y);
        self.label.frame = myFrame;
        [self.label setFont:[UIFont boldSystemFontOfSize:16]];
        
        self.iImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 9, 16, 16)];
        self.iImageView.image = [UIImage imageNamed:@"icon_calendar"];
        [self addSubview:self.iImageView];
        
        self.mCountLabel = [[CountLabel alloc] initWithFrame:CGRectMake([JpUiUtil getScreenWidth]-40, 4, 26, 26)];
        [self.mCountLabel setTextAlignment:NSTextAlignmentCenter];
        [self.mCountLabel setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.mCountLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (void)setCount:(NSString *)count
{
    [self.mCountLabel setText:count];
}

@end
