//
//  JpDataStoreUtil.h
//  JpLib
//
//  Created by Johnny on 26/12/13.
//  Copyright (c) 2013 dbs. All rights reserved.
//

@interface JpDataUtil : NSObject

+ (void) saveDataToUDForKey:(NSString*)key value:(NSObject*)value;
+ (NSString*) getValueFromUDByKey: (NSString*)keyString;
+ (NSDictionary*)getDicFromUDByKey: (NSString*)key;

+ (NSArray *) getJsonArr:(id)aJsonStr;

+ (void)resetDefaults;
@end
