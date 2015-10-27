//
//  CommonFunctions.h
//  SyncService
//
//  Created by Federico Lanzani on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"


@interface CommonFuncBanelco : NSObject {

}

+ (NSString *) returnXMLMasterTagFromTextOrNil:(NSString *)xml withTag:(NSString *)tag;
+ (NSString *) cleanResponseXML:(NSString *)xml;
+ (NSString *) returnXMLMasterTagFromText:(NSString *)xml withTag:(NSString *)tag;
+ (NSString *) returnXMLMasterTagFromSoapText:(NSString *)xml withTag:(NSString *)tag;
+ (NSString *) returnFaultXMLTagFromText:(NSString *)xml;
+ (NSString *) makeXMLSendable:(NSString *)xmlIn;
+ (NSString *) makeXMLLegible:(NSString *)xmlIn;
+ (NSString *) returnXMLTagValue:(GDataXMLDocument *)doc withElement:(NSString *)tag;
+ (NSString *) returnXMLTagValueElement:(GDataXMLElement *)elem withElement:(NSString *)tag;
+ (NSString *) intToNSString:(int)val;
+ (NSString *) dateToNSString:(NSDate *)val withFormat:(NSString *)format;
+ (NSDate *) NSStringToNSDate:(NSString *)val withFormat:(NSString *)format;
+ (NSData *) NSStringToNSData:(NSString *)val;
+ (NSString *) NSDecimalNumberToNSString:(NSDecimalNumber *)val;
+ (NSString *) WSFormat;
+ (NSString *) DBFormat;
+ (NSString *) WSFormatProfileDOB;
+ (NSString *) BEWSFormat;
+ (BOOL) hasNumbers:(NSString *) text;
+ (BOOL) hasNumbersAndPunctuation:(NSString *) text;
+ (BOOL) hasOnlyAlphabet:(NSString *)text;
+ (BOOL) hasAlphabetAndSpecial:(NSString *)text;
+ (BOOL) hasAlphabetAndNumbers:(NSString *)text;
+ (BOOL) hasOnlyWhitespace:(NSString *)text;
+ (BOOL) validateMail:(NSString *)text;
+ (NSString *)WSFormatProfileDOBInSpanish;

+ (BOOL) NSStringToBOOL:(NSString *)val;
+ (BOOL) isNotEmpty:(NSString *)text;
+ (NSDictionary *)getAppPlist;
+ (NSString *) makeStringSendable:(NSString *)input;
+ (UIColor *)UIColorFromRGB:(NSString *)rgbValue;
+ (NSString *)stringWithEscapes:(NSString *)str;

@end
