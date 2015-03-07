//
//  SystemUtil.m
//  ULOCR
//
//  Created by Johnny on 26/12/13.
//  Copyright (c) 2013 dbs. All rights reserved.
//

#import "JpUtil.h"

@implementation JpUtil

// htmlString : <b><big> <br/> <font color='#ff0000'> <div style='font-size:20px;'>
+ (NSMutableAttributedString *) getHtmlAttributedString:(NSString *)htmlString
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:2];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, [attributedString length])];
    //    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0] range:NSMakeRange(0, [attributedString length])];
    //NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    //textAttachment.image = [UIImage imageNamed:@"icon_comment_red"];
    //NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    //[attributedString replaceCharactersInRange:NSMakeRange(0, 2) withAttributedString:attrStringWithImage];
    
    return attributedString;
}

+ (float) getRealHeight:(NSMutableAttributedString *)attributedString width:(float)width
{
    CGSize constrainedSize = CGSizeMake(width, 9999);
    CGRect requiredRect = [attributedString boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return requiredRect.size.height;
}

@end
