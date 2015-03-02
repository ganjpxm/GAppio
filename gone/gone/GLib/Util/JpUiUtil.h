//
//  SystemUtil.h
//  ULOCR
//
//  Created by Johnny on 26/12/13.
//  Copyright (c) 2013 dbs. All rights reserved.
//

@interface JpUiUtil : NSObject


#pragma mark window
+ (float)getScreenHeight;
+ (float)getScreenWidth;
+ (NSInteger)getStartHeightOffset;

#pragma alert
+ (void)showAlertWithMessage:(NSString*)aMessage title:(NSString*)title;

#pragma Image
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)resizeImageWithImage:(UIImage *)image width:(int)width height:(int)height;
+ (UIImage*)getImageWithImageFullName: (NSString*)imageFullName savedImageDirPath:(NSString*)imageDirPath;

#pragma UILabel
+ (CGSize)getTextSizeByUILabel:(UILabel *)aLabel;
@end
