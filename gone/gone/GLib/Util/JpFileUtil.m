//
//  FileUtil.m
//  ULOCR
//
//  Created by Johnny on 26/12/13.
//  Copyright (c) 2013 dbs. All rights reserved.
//

#import "JpFileUtil.h"

@implementation JpFileUtil

+ (NSMutableString*)getUserDocFullPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *path = [NSMutableString stringWithString:[paths objectAtIndex:0]];
    return path;
}

+ (NSMutableString*)getFullPathWithDirName:(NSString*)dirName {
    NSString *userDocDirPath = [JpFileUtil getUserDocFullPath];
    NSString *fullPath = [userDocDirPath stringByAppendingPathComponent:dirName];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:fullPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    return [NSMutableString stringWithString:fullPath];
}

+ (BOOL)deleteMyDocsDirectory:(NSString*)subdir
{
    NSString *documentsDirectory = [self getUserDocFullPath];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:subdir];
    
    NSLog(@"deleteMyDocsDirectory:%@",path);
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL deleted = [fileManager removeItemAtPath:path error:&error];
    if (deleted != YES || error != nil)
    {
        // Deal with the error...
    }
    return deleted;
}

// Dictionary
+ (NSMutableDictionary*)loadDictionary:(NSString *)plistFilename
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [self getUserDocFullPath];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:plistFilename ];
    NSMutableDictionary *dummyNSMutableDictionary = [[NSMutableDictionary alloc] init];
    
    if (![fileManager fileExistsAtPath: path])
    {
        // Let's create the file
        @try {
            NSLog(@"Attempt to save a new MyLoanApplication for %@", plistFilename);
            [dummyNSMutableDictionary writeToFile:path atomically:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"dummyNSMutableDictionary WRITE ERROR in OCR");
        }
        @finally {
            //
            return dummyNSMutableDictionary;
        }
    } else { // ok, file exists
        return [[NSMutableDictionary alloc] initWithContentsOfFile: path];; //[NSDictionary dictionaryWithContentsOfFile:path];
        NSLog(@"%@ exists", plistFilename);
        
    }
}

+ (void)saveImage: (UIImage*)image fileName:(NSString*)fileName subDirectory:(NSString*)subDirectory
{
    if (image != nil)
    {
        //NSData* data = UIImagePNGRepresentation(image);
        NSData* data = UIImageJPEGRepresentation(image, 1.0);
        NSString *path = [subDirectory stringByAppendingPathComponent:fileName];
        NSLog(@"save Image in %@", path);
        [data writeToFile:path atomically:YES];
    }
}

@end
