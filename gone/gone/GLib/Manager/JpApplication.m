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

@synthesize colorPrimary,colorDarkPrimary,colorLightPrimary,colorFront,colorBackground,imageNameNavBackground;

+ (JpApplication *)sharedManager
{
    static JpApplication *sharedManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    return sharedManagerInstance;
}

- (void)initWithPrimaryColor:(UIColor *)primaryColor darkPrimaryColor:(UIColor *)darkPrimaryColor lightPrimaryColor:(UIColor *)lightPrimaryColor frontColor:(UIColor *)frontColor backgroundColor:(UIColor *)backgroundColor navBackgroundImageName:(NSString *)navBackgroundImageName
{
    colorPrimary = primaryColor;
    colorDarkPrimary = darkPrimaryColor;
    colorLightPrimary = lightPrimaryColor;
    colorFront = frontColor;
    colorBackground = backgroundColor;
    imageNameNavBackground = navBackgroundImageName;
}


@end
