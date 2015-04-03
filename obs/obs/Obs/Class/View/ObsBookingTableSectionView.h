//
//  BookingTableSectionView.h
//  obs
//
//  Created by ganjianping on 5/2/15.
//  Copyright (c) 2015 lt. All rights reserved.
//
#import "JpTableSectionView.h"
#import "JpRoundedRectLabel.h"

@interface ObsBookingTableSectionView : JpTableSectionView

@property (nonatomic, strong) UIImageView * iImageView;
@property (nonatomic, strong) CountLabel * mCountLabel;

- (void)setCount:(NSString *)count;

@end
