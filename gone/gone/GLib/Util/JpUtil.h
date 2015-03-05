//
//  JpUtil.h
//  ULOCR
//
//  Created by Johnny on 26/12/13.
//  Copyright (c) 2013 dbs. All rights reserved.
//

@interface JpUtil : NSObject

+ (NSMutableAttributedString *) getHtmlAttributedString:(NSString *)htmlString;
+ (float) getRealHeight:(NSMutableAttributedString *)attributedString width:(float)width;

@end
