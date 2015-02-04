//
//  ObsdBookingVehicleTableCell.m
//  Obsd
//
//  Created by Johnny on 30/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

@interface ObsdBookingVehicleTableCell : UITableViewCell

@property(nonatomic,strong)UILabel *leftTopTV;
@property(nonatomic,strong)UILabel *leftBottomTV;
@property(nonatomic,strong)UIView *middleView;
@property(nonatomic,strong)UILabel *rightTopTV;
@property(nonatomic,strong)UILabel *rightMiddleTV;
@property(nonatomic,strong)UILabel *rightBottomTV;

@property (nonatomic, strong) UIColor * accessoryCheckmarkColor;
@property (nonatomic, strong) UIColor * disclosureIndicatorColor;

- (void)updateContentForNewContentSize;

@end
