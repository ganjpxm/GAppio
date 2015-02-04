//
//  JpConstant.m
//  JpSample
//
//  Created by Johnny on 25/3/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "JpConst.h"

#pragma Key Value
NSString *const KEY_LANG = @"JpLang";
NSString *const VALUE_LANG_ZH_CN = @"zh_CN";
NSString *const VALUE_LANG_EN_SG = @"en_SG";
NSString *const VALUE_LANG_ZH_HANS = @"zh-Hans";
NSString *const VALUE_LANG_EN = @"en";

#pragma error msg
NSString *const ERROR_MSG_NONETWORK = @"Unable to detect a connection to the internet. Please check your phone settings.";
NSString *const ERROR_MSG_TIMEOUT = @"Connection time out. Please try again later. Sorry for the inconvenience caused.";
NSString *const ERROR_MSG_SERVER_DOWN = @"Unable to connect to server. Please try again later. Sorry for the inconvenience caused.";
