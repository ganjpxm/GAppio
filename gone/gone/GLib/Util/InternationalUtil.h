//
//  InternationalUtil.h
//  JOne
//
//  Created by Johnny on 8/12/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

@interface InternationalUtil : NSObject

+(NSBundle *)bundle;
+(void)initUserLanguage;
+(NSString *)userLanguage;
+(void)setUserlanguage:(NSString *)language;

@end
