//
//  JpConstant.h
//  JpLib
//  extern UIColor* const COLOR_LIGHT_BLUE;
//
//  Created by Johnny on 25/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//
//  extern UIColor* const COLOR_LIGHT_BLUE;

#define COLOR_PRIMARY_TEXT [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0]
#define COLOR_SECONDARY_TEXT [UIColor colorWithRed:114.0/255.0 green:114.0/255.0 blue:114.0/255.0 alpha:1.0]
#define COLOR_DIVIDER [UIColor colorWithRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1.0]

#define COLOR_GRAY_DARK_PRIMARY [UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0]
#define COLOR_GRAY_PRIMARY [UIColor colorWithRed:158.0/255.0 green:158.0/255.0 blue:158.0/255.0 alpha:1.0]
#define COLOR_GRAY_LIGHT_PRIMARY [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0]

#define COLOR_BLUE_JP [UIColor colorWithRed:0.0/255.0 green:97.0/255.0 blue:196.0/255.0 alpha:1.0]
#define COLOR_GREEN_JP [UIColor colorWithRed:85.0/255.0 green:220.0/255.0 blue:76.0/255.0 alpha:1.0]
#define COLOR_BLACK_JP [UIColor colorWithRed:28.0/255.0 green:34.0/255.0 blue:46.0/255.0 alpha:1.0]

extern UIColor* const COLOR_GREEN;

#pragma key and value
FOUNDATION_EXPORT NSString *const KEY_LANG;
FOUNDATION_EXPORT NSString *const VALUE_LANG_ZH_CN;
FOUNDATION_EXPORT NSString *const VALUE_LANG_EN_SG;
FOUNDATION_EXPORT NSString *const VALUE_LANG_ZH_HANS;
FOUNDATION_EXPORT NSString *const VALUE_LANG_EN;

#pragma error msg
FOUNDATION_EXPORT NSString *const ERROR_MSG_NONETWORK;
FOUNDATION_EXPORT NSString *const ERROR_MSG_TIMEOUT;
FOUNDATION_EXPORT NSString *const ERROR_MSG_SERVER_DOWN;
