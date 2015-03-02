//
//  JpUtil.m
//  JOne
//
//  Created by Johnny on 2/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

#import "JpSystemUtil.h"
#import "NSString+Jp.h"
#import "JpApplication.h"
#import "JpConst.h"

static NSBundle *bundle = nil;

@implementation JpSystemUtil

#pragma Nav and status bar
+ (void)setNavAndStatusbarStytle:(UINavigationController *)nc
{
    UIColor *colorBackground = [JpApplication sharedManager].colorDarkPrimary;
    UIColor *colorThemeFront = [JpApplication sharedManager].colorFront;
    NSString *navBackgroundImageName = [JpApplication sharedManager].imageNameNavBackground;
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                       colorThemeFront, NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    if ([JpSystemUtil isIOS7orAbove]) {
        if ([navBackgroundImageName length]==0) {
            [[UINavigationBar appearance] setBarTintColor:colorBackground];
            [[UINavigationBar appearance] setTintColor:colorThemeFront];
        } else {
            UIImage *navBackgroundImage = [UIImage imageNamed:navBackgroundImageName];
            [nc.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//View controller-based status bar appearance : NO
        }
    } else {
        [nc.navigationBar setTintColor:colorBackground];
    }
}

#pragma system
+ (NSString *)getSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
+ (BOOL)isIOS5orAbove
{
    return ([self.getSystemVersion compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending);
}
+ (BOOL)isIOS6orAbove
{
    return ([self.getSystemVersion compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending);
}
+ (BOOL)isIOS7orAbove
{
    //return floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1;
    return ([self.getSystemVersion compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending);
}

#pragma device
+ (NSString *)getDeviceName
{
    return [[UIDevice currentDevice] name];
}
+ (BOOL)isIpad
{
    return [UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad;
}
+ (BOOL)isRetina
{
    return [UIScreen mainScreen].scale > 1;
}
+ (BOOL)isLandscape
{
    return (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation));
}
+ (BOOL)isPortrait
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

#pragma Lang
+ (NSBundle *)getBundle
{
    return bundle;
}
+ (void)initAppLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *lang = [def valueForKey:KEY_LANG];
    
    if ([lang isEqualToString:VALUE_LANG_ZH_CN]) {
        lang = VALUE_LANG_ZH_HANS;
    } else if ([lang isEqualToString:VALUE_LANG_EN_SG]) {
        lang = VALUE_LANG_EN;
    } else {
        lang = self.getPreferredLanguage;
        if (![lang isEqualToString:VALUE_LANG_ZH_HANS]) {
            lang = VALUE_LANG_EN;
        }
        [def setValue:lang forKey:KEY_LANG];
        [def synchronize];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
}
+ (NSString *)getAppLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:KEY_LANG];
    return language;
}
+ (void)setAppLanguage:(NSString *)language{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
    [def setValue:language forKey:KEY_LANG];
    [def synchronize];
}
+ (NSString *)getLocalizedStr:(NSString *)aKey
{
    return [bundle localizedStringForKey:aKey value:nil table:nil];
    //    return NSLocalizedString(aKey, nil);
}
+ (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    return [languages objectAtIndex:0];
}
+ (NSMutableArray *)getLocalizedArr:(NSString *)aKey
{
    NSString *localizedStr = [JpSystemUtil getLocalizedStr:aKey];
    return [localizedStr toArr];
}
+ (NSMutableDictionary *)getLocalizedDic:(NSString *)aKey
{
    NSString *localizedStr = [JpSystemUtil getLocalizedStr:aKey];
    return [localizedStr toDic];
}

@end
