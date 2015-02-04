//
//  SystemUtil.h
//  ULOCR
//
//  Created by Johnny on 26/12/13.
//  Copyright (c) 2013 dbs. All rights reserved.
//

@interface JpDataStoreUtil : NSObject

+ (void) saveDataToUserDefaultsForKey:(NSString*)key value:(NSObject*)value;
+ (NSString*) getValueFromUserDefaultByKey: (NSString*)keyString;

@end
