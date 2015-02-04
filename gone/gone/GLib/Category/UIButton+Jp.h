//
//  UIButton+Jp.h
//  JpSample
//
//  Created by Johnny on 22/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

@interface UIButton (Jp)

/*
 * @brief Create a new UIScrollView and return the view.
 *
 * @param target : self
 * @param action : @selector(onClickStartOverBtn:)
 * @param fontName : Helvetica-Bold
 *
 * @return UIButton
 */
+ (UIButton *)createButtonWithTitle:(NSString *)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height target:(id)target action:(SEL)action imgName:(NSString *)imgName bgImgName:(NSString *)bgImgName bgPressImgName:(NSString *)bgPressImgName bgColor:(UIColor *)bgColor  titleColor:(UIColor *)titleColor font:(UIFont *)font tag:(NSInteger)tag isEnable:(BOOL)isEnable isHidden:(BOOL)isHidden;

+ (UIButton *)createNavBarBtnWithTitle:title imgName:(NSString *)imgName target:(id)target action:(SEL)action;

- (void)addActionWithTarget:(id)target action:(SEL)action;

@end
