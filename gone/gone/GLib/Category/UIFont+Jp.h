//
//  UIFont+Jp.h
//  JpSample
//
//  Created by Johnny on 23/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

@interface UIFont (Jp)

+ (UIFont *)appFontWithSize:(CGFloat)fontSize;
+ (UIFont *)appFontBoldWithSize:(CGFloat)fontSize;
+ (UIFont *)appFontRomanWithSize:(CGFloat)fontSize;
+ (UIFont *)appFont75BlackWithSize:(CGFloat)fontSize;

- (UIFont *)appFont;
- (UIFont *)appFontBold;
- (UIFont *)appFontRoman;

@end
