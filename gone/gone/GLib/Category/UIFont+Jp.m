//
//  UIFont+Jp.m
//  JpSample
//
//  Created by Johnny on 23/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "UIFont+Jp.h"
#import "JpSystemUtil.h"

#define APP_FONT          @"Frutiger45-Light"
#define APP_FONT_BOLD     @"Frutiger-Bold"
#define APP_FONT_ROMAN    @"FrutigerLTStd-Roman"
#define APP_FONT_75_BLACK @"FrutigerLTStd-Black"

@implementation UIFont (Jp)

+ (void)load
{
    [super load];
}

+ (UIFont *)appFontWithSize:(CGFloat)fontSize
{
    if ([JpSystemUtil isIpad]) {
        fontSize += 7;
    }
    return [UIFont fontWithName:APP_FONT size:fontSize];
}

+ (UIFont *)appFontBoldWithSize:(CGFloat)fontSize
{
    if ([JpSystemUtil isIpad])
        fontSize += 7;
    return [UIFont fontWithName:APP_FONT_BOLD size:fontSize];
}

+ (UIFont *)appFontRomanWithSize:(CGFloat)fontSize
{
    if ([JpSystemUtil isIpad])
        fontSize += 7;
    return [UIFont fontWithName:APP_FONT_ROMAN size:fontSize];
}

+ (UIFont *)appFont75BlackWithSize:(CGFloat)fontSize
{
    if ([JpSystemUtil isIpad])
        fontSize += 7;
    return [UIFont fontWithName:APP_FONT_75_BLACK size:fontSize];
}

- (UIFont *)appFont
{
    CGFloat fontSize = self.pointSize;
    return [UIFont fontWithName:APP_FONT size:fontSize];
}

- (UIFont *)appFontBold
{
    CGFloat fontSize = self.pointSize;
    return [UIFont fontWithName:APP_FONT_BOLD size:fontSize];
}

- (UIFont *)appFontRoman
{
    CGFloat fontSize = self.pointSize;
    return [UIFont fontWithName:APP_FONT_ROMAN size:fontSize];
}

@end
