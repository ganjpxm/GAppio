//
//  JpUtil.m
//  JOne
//
//  Created by Johnny on 2/11/13.
//  Copyright (c) 2013 ganjp. All rights reserved.
//

#import "SystemUtil.h"
#import "NSString+Jp.h"
#import "InternationalUtil.h"

@implementation SystemUtil

+ (void)AlertShow:(NSString*)aMsgStr Title:(NSString*)aTitle
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:aTitle
                          message: aMsgStr
                          delegate:Nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil];
    [alert show];
}

+ (float)window_height   {
    return [UIScreen mainScreen].applicationFrame.size.height;
}

+ (float)window_width   {
    return [UIScreen mainScreen].applicationFrame.size.width;
}

+ (BOOL)OSVersionIsAtLeastiOS7
{
    return floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1;
}

+ (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}

+ (CGSize)getTextSizeWithUILabel:(UILabel *)aLabel
{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:aLabel.text];
    aLabel.attributedText = attrStr;
    NSRange range = NSMakeRange(0, attrStr.length);
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    CGSize textSize = [aLabel.text boundingRectWithSize:aLabel.bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return textSize;
    
    //CGSize s = [descriptionLabel.text sizeWithFont:descriptionLabel.font constrainedToSize:CGSizeMake(frame.size.width-40, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}

+ (NSString *)getLocalizedStr:(NSString *)aKey
{
    NSBundle *bundle = [InternationalUtil bundle];
    return [bundle localizedStringForKey:aKey value:nil table:nil];
//    return NSLocalizedString(aKey, nil);
}

+ (NSMutableArray *)getLocalizedArr:(NSString *)aKey
{
    NSString *localizedStr = [SystemUtil getLocalizedStr:aKey];
    return [localizedStr toArr];
}

+ (NSMutableDictionary *)getLocalizedDic:(NSString *)aKey
{
    NSString *localizedStr = [SystemUtil getLocalizedStr:aKey];
    return [localizedStr toDic];
}


@end
