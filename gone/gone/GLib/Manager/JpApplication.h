//
//  JpApplication.h
//  JpSample
//
//  Created by Johnny on 25/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

@interface JpApplication : NSObject

@property (nonatomic,strong) UIColor *colorTheme;
@property (nonatomic,strong) UIColor *colorFront;
@property (nonatomic,strong) UIColor *colorBackground;
@property (nonatomic,strong) NSString *imageNameNavBackground;

+ (JpApplication *)sharedManager;
- (void)initWithThemeColor:(UIColor *)themeColor frontColor:(UIColor *)frontColor backgroundColor:(UIColor *)backgroundColor navBackgroundImageName:(NSString *)navBackgroundImageName;
@end
