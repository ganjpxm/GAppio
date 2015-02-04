//
//  JpUtil.h
//  JOne
//
//  Created by Johnny on 2/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

@interface SystemUtil : NSObject

+ (void)AlertShow:(NSString*)aMsgStr Title:(NSString*)aTitle;

+ (float)window_height;
+ (float)window_width;

+ (BOOL)OSVersionIsAtLeastiOS7;
+ (NSString*)getPreferredLanguage;

+ (CGSize)getTextSizeWithUILabel:(UILabel *)aLabel;

+ (NSString *)getLocalizedStr:(NSString *)aKey;
+ (NSMutableArray *)getLocalizedArr:(NSString *)aKey;
+ (NSMutableDictionary *)getLocalizedDic:(NSString *)aKey;

@end
