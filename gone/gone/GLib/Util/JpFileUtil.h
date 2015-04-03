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
+ (void)saveImage: (UIImage*)image imageType:(NSString *)imageType fileName:(NSString*)fileName subDirectory:(NSString*)subDirectory;
+ (BOOL)deleteImage:(NSString*)fileName subDirectory:(NSString*)subDirectory;

+ (UIImage *) addText:(UIImage *)img text:(NSString *)mark withRect:(CGRect)rect;

@end
