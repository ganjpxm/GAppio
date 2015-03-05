//
//  ObsdBookingVehicleTableCell.m
//  Obsd
//
//  Created by Johnny on 30/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

@interface ObsBookingAlertTableCell : UITableViewCell

@property(nonatomic,strong)UILabel *bookingInfoTV;

@property(nonatomic,strong)UIButton *acceptBtn;
@property(nonatomic,strong)UIButton *rejectBtn;

- (void)updateContentForNewContentSize;

@end
