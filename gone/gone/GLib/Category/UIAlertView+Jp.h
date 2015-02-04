//
//  UIAlertView+Jp.h
//  JpSample
//
//  Created by Johnny on 23/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

@interface UIAlertView (Jp)

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message tag:(NSInteger)tag delegate:(id<UIAlertViewDelegate>)delegate buttonTitles:(NSString *)firstTitle, ...;
    
@end
