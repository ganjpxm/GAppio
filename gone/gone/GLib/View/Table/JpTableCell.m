//
//  JpTableCell.m
//  JOne
//
//  Created by Johnny on 30/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

#import "JpTableCell.h"
#import "JpApplication.h"

@implementation JpTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIColor *colorTheme = [[JpApplication sharedManager] colorPrimary];
        
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
        
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setTextColor:[UIColor blackColor]];
        if(floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1){
            [self.textLabel setShadowColor:[[UIColor blackColor] colorWithAlphaComponent:.5]];
            [self.textLabel setShadowOffset:CGSizeMake(0, 1)];
        }
        
        [self setAccessoryCheckmarkColor:colorTheme];
    }
    return self;
}

//- (void)setFrame:(CGRect)frame {
//    frame.origin.x += 30;
//    frame.size.width -= 2 * 30;
//    [super setFrame:frame];
//}

- (void)updateContentForNewContentSize
{
    if ([[UIFont class] respondsToSelector:@selector(preferredFontForTextStyle:)]) {
        [self.textLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    } else {
        [self.textLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    }
}

@end
