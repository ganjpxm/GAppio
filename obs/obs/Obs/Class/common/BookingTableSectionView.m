//
//  BookingTableSectionView.m
//  obs
//
//  Created by ganjianping on 5/2/15.
//  Copyright (c) 2015 lt. All rights reserved.
//

#import "BookingTableSectionView.h"


@interface BookingTableSectionView ()

@end

@implementation BookingTableSectionView

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
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

@end
