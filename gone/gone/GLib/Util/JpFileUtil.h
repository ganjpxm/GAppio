//
//  FileUtil.h
//  ULOCR
//
//  Created by Johnny on 26/12/13.
//  Copyright (c) 2013 dbs. All rights reserved.
//

@interface JpFileUtil : NSObject

+ (NSMutableString*)getUserDocFullPath;
+ (NSMutableString*)getFullPathWithDirName:(NSString*)dirName;
+ (NSMutableDictionary*)loadDictionary:(NSString *)plistFilename;

+ (BOOL)deleteMyDocsDirectory:(NSString*)subdir;
+ (void)saveImage: (UIImage*)image fileName:(NSString*)fileName subDirectory:(NSString*)subDirectory;

@end
