//
//  NSString+Jp.m
//  JpSample
//
//  Created by Johnny on 22/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

#import "NSString+Jp.h"

@implementation NSString (Jp)

- (BOOL)isEmpty
{
    return ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0);
}

- (NSString *)URLEncodedString
{
    NSString *result = ( NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!*();+$,%#[] "),  kCFStringEncodingUTF8));
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = ( NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
    return result;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:NSCaseInsensitiveSearch];
}

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (NSString*)htmlToText
{
    if (self.isEmpty) {
        return @"";
    }
    NSString *text;
    text = [self stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    text = [text stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    text = [text stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    text = [text stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
    text = [text stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    text = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    return text;
}

- (NSString*)textToHtml
{
    if (self.isEmpty) {
        return @"";
    }
    NSString *text;
    text = [self stringByReplacingOccurrencesOfString:@"&"  withString:@"&amp;"];
    text = [text stringByReplacingOccurrencesOfString:@"<"  withString:@"&lt;"];
    text = [text stringByReplacingOccurrencesOfString:@">"  withString:@"&gt;"];
    text = [text stringByReplacingOccurrencesOfString:@"""" withString:@"&quot;"];
    text = [text stringByReplacingOccurrencesOfString:@"'"  withString:@"&#039;"];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    return text;
}

//China,Singapore
- (NSMutableArray*)toArr
{
    if (self.isEmpty) {
       return NULL;
    }
    return [[NSMutableArray alloc] initWithArray:[self componentsSeparatedByString:@","]];
}

//Coutry:China,Singapore;Gender:Male,Femal;
- (NSMutableDictionary*)toDic
{
    if (self.isEmpty || ![self containsString:@";"] || ![self containsString:@":"]) {
        return NULL;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *keyValues = [self componentsSeparatedByString:@";"];
    for (NSString *keyValue in keyValues) {
        if ([keyValue length]>0 && [keyValue containsString:@":"]) {
            NSArray *keyValueArr = [keyValue componentsSeparatedByString:@":"];
            [dic setObject:keyValueArr[1] forKey:keyValueArr[0]];
        }
    }
    return dic;
}

//Coutry:China,Singapore;Gender:Male,Femal;
- (NSString*)getAllValuesWithComma
{
    if (self.isEmpty) {
        return @"";
    }
    NSMutableString *valuesWithComma = [[NSMutableString alloc]init];
    NSArray *keyValues = [self componentsSeparatedByString:@";"];
    for (NSString *keyValue in keyValues) {
        if ([keyValue length]>0 && [keyValue containsString:@":"]) {
            NSArray *keyValueArr = [keyValue componentsSeparatedByString:@":"];
            [valuesWithComma appendFormat:@"%@%@", keyValueArr[1], @","];
        }
    }
    NSRange range = NSMakeRange([valuesWithComma length]-1,1);
    [valuesWithComma replaceCharactersInRange:range withString:@""];
    return valuesWithComma;
}

@end
