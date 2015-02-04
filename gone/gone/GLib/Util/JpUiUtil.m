//
//  SystemUtil.m
//  ULOCR
//
//  Created by Johnny on 26/12/13.
//  Copyright (c) 2013 dbs. All rights reserved.
//

#import "JpUiUtil.h"
#import "JpSystemUtil.h"

@implementation JpUiUtil

#pragma mark Window
+ (float)getWindowHeight   {
    return [UIScreen mainScreen].applicationFrame.size.height;
}

+ (float)getWindowWidth   {
    return [UIScreen mainScreen].applicationFrame.size.width;
}

+ (NSInteger)getStartHeightOffset
{
    if ([JpSystemUtil isIOS7orAbove])
    {
        return 20;
    } else {
        return 0;
    }
}

#pragma alert
+ (void)showAlertWithMessage:(NSString*)aMessage title:(NSString*)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:aMessage delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma Image
+ (UIImage *)resizeImageWithImage:(UIImage *)image width:(int)width height:(int)height
{
    CGImageRef imageRef = [image CGImage];
    CGImageAlphaInfo alphaInfo1 = CGImageGetAlphaInfo(imageRef);
    
    //if (alphaInfo == kCGImageAlphaNone)
    alphaInfo1 = kCGImageAlphaNoneSkipLast;
    CGBitmapInfo alphaInfo = (CGBitmapInfo) alphaInfo1;
    CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef),
                                                4 * width, CGImageGetColorSpace(imageRef), alphaInfo);
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *resizedImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return resizedImage;
}
+ (UIImage*)getImageWithImageFullName:(NSString*)imageFullName savedImageDirPath:(NSString*)imageDirPath
{
    NSString *imageFullPath = [imageDirPath stringByAppendingPathComponent:imageFullName];
    return [UIImage imageWithContentsOfFile:imageFullPath];
}

#pragma UILabel
+ (CGSize)getTextSizeByUILabel:(UILabel *)aLabel
{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:aLabel.text];
    aLabel.attributedText = attrStr;
    NSRange range = NSMakeRange(0, attrStr.length);
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    CGSize textSize = [aLabel.text boundingRectWithSize:aLabel.bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return textSize;
}
@end
