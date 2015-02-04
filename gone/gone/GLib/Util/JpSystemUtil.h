//
//  SystemUtil.h
//  JpLib
//
//  Created by Johnny on 2/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

@interface JpSystemUtil : NSObject

#pragma Nav and status bar
+ (void)setNavAndStatusbarStytle:(UIViewController *)vc;

#pragma system
+ (NSString *)getSystemVersion;
+ (BOOL)isIOS5orAbove;
+ (BOOL)isIOS6orAbove;
+ (BOOL)isIOS7orAbove;

#pragma device
+ (NSString *)getDeviceName;
+ (BOOL)isIpad;
+ (BOOL)isRetina;
+ (BOOL)isLandscape;
+ (BOOL)isPortrait;

#pragma Lang
+ (NSBundle *)getBundle;
+ (void)initAppLanguage;
+ (NSString *)getAppLanguage;
+ (void)setAppLanguage:(NSString *)language;
+ (NSString *)getLocalizedStr:(NSString *)aKey;
+ (NSString*)getPreferredLanguage;
+ (NSMutableArray *)getLocalizedArr:(NSString *)aKey;
+ (NSMutableDictionary *)getLocalizedDic:(NSString *)aKey;
@end
