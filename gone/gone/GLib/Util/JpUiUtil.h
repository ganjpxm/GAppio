//
//  SystemUtil.h
//  ULOCR
//
//  Created by Johnny on 26/12/13.
//  Copyright (c) 2013 dbs. All rights reserved.
//

@interface JpUiUtil : NSObject


#pragma mark window
+ (float)getWindowHeight;
+ (float)getWindowWidth;
+ (NSInteger)getStartHeightOffset;

#pragma alert
+ (void)showAlertWithMessage:(NSString*)aMessage title:(NSString*)title;

#pragma Image
+ (UIImage *)resizeImageWithImage:(UIImage *)image width:(int)width height:(int)height;
+ (UIImage*)getImageWithImageFullName: (NSString*)imageFullName savedImageDirPath:(NSString*)imageDirPath;

#pragma UILabel
+ (CGSize)getTextSizeByUILabel:(UILabel *)aLabel;
@end
