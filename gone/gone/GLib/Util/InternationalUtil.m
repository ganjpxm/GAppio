//
//  InternationalUtil.m
//  JOne
//
//  Created by Johnny on 8/12/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//
static NSBundle *bundle = nil;

#import "InternationalUtil.h"
#import "JpConst.h"

@implementation InternationalUtil

+ (NSBundle *)bundle
{
    return bundle;
}

+ (void)initUserLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:KEY_LANG];

    if(string.length == 0){
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        NSString *current = [languages objectAtIndex:0];
        string = current;
        [def setValue:current forKey:KEY_LANG];
        [def synchronize];
    } else if ([string isEqualToString:VALUE_LANG_ZH_CN]) {
        string = VALUE_LANG_ZH_HANS;
    } else if ([string isEqualToString:VALUE_LANG_EN_SG]) {
        string = VALUE_LANG_EN;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
}

+ (NSString *)userLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:KEY_LANG];
    return language;
}

+(void)setUserlanguage:(NSString *)language{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
    [def setValue:language forKey:KEY_LANG];
    [def synchronize];
}
@end
