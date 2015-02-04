//
//  JpApplication.m
//  JpSample
//
//  Created by Johnny on 25/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "JpApplication.h"

@interface JpApplication ()

@end

@implementation JpApplication

@synthesize colorTheme,colorFront,colorBackground,imageNameNavBackground;

+ (JpApplication *)sharedManager
{
    static JpApplication *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (void)initWithThemeColor:(UIColor *)themeColor frontColor:(UIColor *)frontColor backgroundColor:(UIColor *)backgroundColor navBackgroundImageName:(NSString *)navBackgroundImageName
{
    colorTheme = themeColor;
    colorFront = frontColor;
    colorBackground = backgroundColor;
    imageNameNavBackground = navBackgroundImageName;
}


@end
