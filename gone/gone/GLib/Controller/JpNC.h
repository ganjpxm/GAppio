//
//  JpNC.h
//  JpSample
//
//  Created by Johnny on 23/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//
@interface JpNC : UINavigationController

@end

@interface UINavigationItem (CustomTitle)

- (void)setCustomTitle:(NSString *)newTitle;
- (void)setTitleButton:(NSString *)newTitle atTarget:(id)target action:(SEL)action;
- (void)setLeftButtonforTarget:(id)target action:(SEL)action;

@end