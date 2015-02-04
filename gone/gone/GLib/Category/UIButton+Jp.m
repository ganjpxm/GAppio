//
//  UIButton+Jp.m
//  JpSample
//
//  Created by Johnny on 22/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "UIButton+Jp.h"
#import "NSString+Jp.h"
#import "UIFont+Jp.h"

@implementation UIButton (Jp)

/*
 * @brief Create a new UIScrollView and return the view.
 *
 * @param target : self
 * @param action : @selector(onClickStartOverBtn:)
 * @param fontName : Helvetica-Bold
 *
 * @return UIButton
 */
+ (UIButton *)createButtonWithTitle:(NSString *)title x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height target:(id)target action:(SEL)action imgName:(NSString *)imgName bgImgName:(NSString *)bgImgName bgPressImgName:(NSString *)bgPressImgName bgColor:(UIColor *)bgColor  titleColor:(UIColor *)titleColor font:(UIFont *)font tag:(NSInteger)tag isEnable:(BOOL)isEnable isHidden:(BOOL)isHidden
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    UIImage *bgImg;
    if (!bgImgName.isEmpty) {
        bgImg = [UIImage imageNamed:bgImgName];
        [btn setBackgroundImage:bgImg forState:UIControlStateNormal];
    }
    if (!bgPressImgName.isEmpty) {
        UIImage *bgPressImg = [UIImage imageNamed:bgPressImgName];
        [btn setBackgroundImage:bgPressImg forState:UIControlStateSelected];
    }
    if (!bgPressImgName.isEmpty) {
        UIImage *img = [UIImage imageNamed:imgName];
        [btn setImage:img forState:UIControlStateNormal];
    }
    
    if (width==0) {
        width = bgImg.size.width;
    }
    if (height==0) {
        width = bgImg.size.height;
    }
    [btn setFrame:CGRectMake(x, y, width, height)];
    
    [btn setTag:tag];
    if (bgColor) {
        [btn setBackgroundColor:bgColor];
    }
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (font) {
        [btn.titleLabel setFont:font];
    }
    if (target && action) {
        [btn addActionWithTarget:target action:action];
    }
    [btn setEnabled:isEnable];
    [btn setHidden:isHidden];
    return btn;
}

+ (UIButton *)createNavBarBtnWithTitle:(NSString *)title imgName:(NSString *)imgName target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton createButtonWithTitle:title x:0 y:0 width:0 height:0 target:target action:action imgName:imgName bgImgName:@"btn_navbar_normal" bgPressImgName:@"btn_navbar_pressed" bgColor:Nil titleColor:[UIColor whiteColor] font:[UIFont appFontBoldWithSize:10] tag:0 isEnable:YES isHidden:NO];
    return btn;
}

- (void)addActionWithTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
