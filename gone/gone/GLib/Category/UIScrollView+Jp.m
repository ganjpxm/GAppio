//
//  UIScrollView+Jp.m
//  JpSample
//
//  Created by Johnny on 22/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "UIScrollView+Jp.h"

@implementation UIScrollView (Jp)

/*
 * @brief Create a new UIScrollView and return the view.
 *
 * @param newScrollViewWithScrollEnable : YES/NO
 * @param showsVerticalScrollIndicator : YES/NO
 * @param showsHorizontalScrollIndicator : YES/NO
 * @param color : [UIColor clearColor]
 */
+ (UIScrollView *)newScrollViewWithScrollEnable:(BOOL)isScrollEnable x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width
    height:(CGFloat)height color:(UIColor *)color
    showsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator
    showsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator
{
    UIScrollView  *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(x, y, width, height);
    scrollView.backgroundColor = color;
    scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    scrollView.scrollEnabled = isScrollEnable;
    return scrollView;
}

@end
