//
//  NSString+Jp.h
//  JpSample
//
//  Created by Johnny on 22/2/14.
//  Copyright (c) 2014 ganjp. All rights reserved.
//

@interface NSString (Jp)


- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
- (NSString*)htmlToText;
- (NSString*)textToHtml;

- (BOOL)isEmpty;
- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options;

//China,Singapore
- (NSMutableArray*)toArr;
//Coutry:China,Singapore;Gender:Male,Femal;
- (NSMutableDictionary*)toDic;
//Coutry:China,Singapore;Gender:Male,Femal;
- (NSString*)getAllValuesWithComma;

- (int)indexOf:(NSString *)text;


@end
