//
//  CommonFunctions.m
//  SyncService
//
//  Created by Federico Lanzani on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CommonFuncBanelco.h"
#import "GDataXMLNode.h"
#import "NSData64baseString.h"


@implementation CommonFuncBanelco

+ (NSString *) cleanResponseXML:(NSString *)xml {
	
	NSString *cleaned = [xml stringByReplacingOccurrencesOfString:@"ns1:" withString:@""];
	
	cleaned = [cleaned stringByReplacingOccurrencesOfString:@"ns2:" withString:@""];
	
	cleaned = [cleaned stringByReplacingOccurrencesOfString:@"xsi:" withString:@""];
	
	return cleaned;
	
}

+ (NSString *) returnXMLMasterTagFromTextOrNil:(NSString *)xml withTag:(NSString *)tag {
    
	xml = [self cleanResponseXML:xml];
	
	NSRange match, match2;
	NSString *tag1, *tag2;
	
	tag1 = [NSString stringWithFormat:@"<%@>",tag];
	tag2 = [NSString stringWithFormat:@"</%@>",tag];
	
	match = [xml rangeOfString: tag1];
	match2 = [xml rangeOfString: tag2];
	
	if (match.location > xml.length || match2.location > xml.length) {
		return nil;
	}
	else {
		
		return [xml substringWithRange:NSMakeRange(match.location, (match2.location-match.location+match2.length))];
	}
}

+ (NSString *) returnXMLMasterTagFromText:(NSString *)xml withTag:(NSString *)tag {

	xml = [self cleanResponseXML:xml];
	
	NSRange match, match2;
	NSString *tag1, *tag2;
	
	tag1 = [NSString stringWithFormat:@"<%@>",tag];
	tag2 = [NSString stringWithFormat:@"</%@>",tag];	
	
	match = [xml rangeOfString: tag1];
	match2 = [xml rangeOfString: tag2];	
	
	if (match.location > xml.length || match2.location > xml.length) {
		return xml;
	}
	else {
		
		return [xml substringWithRange:NSMakeRange(match.location, (match2.location-match.location+match2.length))];
	}
}

+ (NSString *) returnXMLMasterTagFromSoapText:(NSString *)xml withTag:(NSString *)tag {
    
	xml = [self cleanResponseXML:xml];
	
	NSRange match, match2;
	NSString *tag1, *tag2;
	
	tag1 = [NSString stringWithFormat:@"<%@",tag];
	tag2 = [NSString stringWithFormat:@"</%@>",tag];
	
	match = [xml rangeOfString: tag1];
	match2 = [xml rangeOfString: tag2];
	
	if (match.location > xml.length || match2.location > xml.length) {
		return xml;
	}
	else {
		
		return [xml substringWithRange:NSMakeRange(match.location, (match2.location-match.location+match2.length))];
	}
}

+ (NSString *) returnFaultXMLTagFromText:(NSString *)xml {
	
	NSRange match, match2;
	
	match = [xml rangeOfString: @"<soap:Fault>"];
	match2 = [xml rangeOfString: @"</soap:Fault>"];	
	
	if (match.location > xml.length || match2.location > xml.length) {
		
		return nil;
		
	} else {
		
		NSString *m = [xml substringWithRange:NSMakeRange(match.location, (match2.location-match.location+match2.length))];
		return [m stringByReplacingOccurrencesOfString:@"soap:" withString:@""];
		
	}
}

+ (NSString *) makeXMLSendable:(NSString *)xmlIn
{
	NSString * xmlFinal = [xmlIn stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
	xmlFinal = [xmlFinal stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
	xmlFinal = [xmlFinal stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
	return xmlFinal;
}

+ (NSString *) makeXMLLegible:(NSString *)xmlIn
{
	NSString * xmlFinal = [xmlIn stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
	xmlFinal = [xmlFinal stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
	xmlFinal = [xmlFinal stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
	xmlFinal = [xmlFinal stringByReplacingOccurrencesOfString:@"</Field><Field>" withString:@"</Field>\n<Field>"];
	return xmlFinal;
}

+ (NSString *) intToNSString:(int)val
{
	if (val == INT_MIN) {
		return [NSString stringWithFormat:@""];
	}else {
		return [NSString stringWithFormat:@"%i",val];
	}
}
	

+  (NSString *) dateToNSString:(NSDate *)val withFormat:(NSString *)format
{
	if (val ==nil) {
		return [NSString stringWithFormat:@""];
	}
	else 
	{
		NSDateFormatter *p = [[[NSDateFormatter alloc] init] autorelease];
		[p setDateFormat:format];
        
        //setea locale en en_GB para obtener siempre fecha en formato de 24hs
        NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        [p setLocale:formatterLocale];
        [formatterLocale release];
		
		NSString *formatted = [NSString stringWithFormat:@"%@",[p stringFromDate:val]];
		return formatted;
	}
}

+  (NSDate *) stringToDate:(NSString *)val withFormat:(NSString *)format
{
	NSDateFormatter *p = [[[NSDateFormatter alloc] init] autorelease];
	[p setDateFormat:format];
	
	
	return [p dateFromString:val];
}

+ (NSString *) DBFormat
{
		return @"yyyyMMddHHmmss";
	
}

+ (NSString *) WSFormat
{
	return @"yyyy-MM-dd";
	
}

+ (NSString *) WSFormatProfileDOB
{
	return @"MM/dd/yyyy";
	
}

+ (NSString *) WSFormatProfileDOBInSpanish
{
	return @"dd/MM/yyyy";
	
}


+ (NSString *) BEWSFormat
{
	return @"yyyy-MM-dd'T'HH:mm:ss.SS";
	
}

+ (NSString *) NSDecimalNumberToNSString:(NSDecimalNumber *)val
{
	if (val==nil) {
		return [NSString stringWithFormat:@""];
	}
	else {
		return [NSString stringWithFormat:@"%@",val];
	}
}



+  (NSDate *) NSStringToNSDate:(NSString *)val withFormat:(NSString *)format
{

	NSDateFormatter *p = [[[NSDateFormatter alloc] init] autorelease];
    
    //setea locale en en_GB para obtener siempre fecha en formato de 24hs
    NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [p setLocale:formatterLocale];
    [formatterLocale release];
    
	[p setDateFormat:format];
	return [p dateFromString:val];
}


+ (NSData *) NSStringToNSData:(NSString *)val
{
	//[[val dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:NO] writeToFile:@"/Users/flanzani/haaaa.png" atomically:NO];
	//return [val dataUsingEncoding: data allowLossyConversion:NO];	
	return [NSData dataWithBase64EncodedString:val];
}


+ (BOOL) NSStringToBOOL:(NSString *)val
{
	//[[val dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:NO] writeToFile:@"/Users/flanzani/haaaa.png" atomically:NO];
	//return [val dataUsingEncoding: data allowLossyConversion:NO];	
	if ([val isEqualToString:@"true"]) {
		return YES;
	}else {
		return NO;
	}

}


+ (NSString *) returnXMLTagValue:(GDataXMLDocument *)doc withElement:(NSString *)tag
{

	NSArray *aux = [doc.rootElement elementsForName:tag];
	if (aux.count > 0)
	{
		GDataXMLElement *elem = (GDataXMLElement *) [aux objectAtIndex:0];
		return elem.stringValue;
	}else {
		return @"";
	}
}

+ (NSString *) returnXMLTagValueElement:(GDataXMLElement *)elem withElement:(NSString *)tag
{
	
	NSArray *aux = [elem elementsForName:tag];
	if (aux.count > 0)
	{
		GDataXMLElement *elem = (GDataXMLElement *) [aux objectAtIndex:0];
		return elem.stringValue;
	}else {
		return @"";
	}
}

+ (BOOL) hasNumbers:(NSString *) text {
	
	NSScanner *scan = [[[NSScanner alloc] initWithString:text] autorelease];
	
	NSString *result = nil;
	
	[scan scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] intoString:&result];
	
	
	/*
	NSString *replaced  = [text stringByReplacingOccurrencesOfString:@"0" withString:@""];
	replaced  = [replaced stringByReplacingOccurrencesOfString:@"1" withString:@""];
	replaced  = [replaced stringByReplacingOccurrencesOfString:@"2" withString:@""];
	replaced  = [replaced stringByReplacingOccurrencesOfString:@"3" withString:@""];
	replaced  = [replaced stringByReplacingOccurrencesOfString:@"4" withString:@""];	
	replaced  = [replaced stringByReplacingOccurrencesOfString:@"5" withString:@""];
	replaced  = [replaced stringByReplacingOccurrencesOfString:@"6" withString:@""];
	replaced  = [replaced stringByReplacingOccurrencesOfString:@"7" withString:@""];
	replaced  = [replaced stringByReplacingOccurrencesOfString:@"8" withString:@""];	
	replaced  = [replaced stringByReplacingOccurrencesOfString:@"9" withString:@""];	
	*/
	if ([result length] == [text length]){
		return YES;
	}
	return NO;
}

+ (BOOL) hasNumbersAndPunctuation:(NSString *) text {
	
	NSScanner *scan = [[[NSScanner alloc] initWithString:text] autorelease];
	
	NSString *result = nil;
	
	[scan scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789,"] intoString:&result];
	
	if ([result length] == [text length]){
		return YES;
	}
	return NO;
}


+(BOOL) hasOnlyAlphabet:(NSString *)text
{
	NSScanner *scan = [[[NSScanner alloc] initWithString:text] autorelease];
	
	NSString *result = nil;
	
	[scan scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNÑOPQRSTUVXWYZabcdefghijklmnñopqrstuvxwyzÁÉÍÓÚáéóíú"] intoString:&result];
	
	if ([result length] == [text length]){
		return YES;
	}
	return NO;
}

+(BOOL) hasAlphabetAndSpecial:(NSString *)text
{
	NSScanner *scan = [[[NSScanner alloc] initWithString:text] autorelease];
	
	NSString *result = nil;
	
	[scan scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNÑOPQRSTUVXWYZabcdefghijklmnñopqrstuvxwyzÁÉÍÓÚáéóíú_-.0123456789"] intoString:&result];
	
	if ([result length] == [text length]){
		return YES;
	}
	return NO;
}

+(BOOL) hasAlphabetAndNumbers:(NSString *)text
{
	NSScanner *scan = [[[NSScanner alloc] initWithString:text] autorelease];
	
	NSString *result = nil;
	
	[scan scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNÑOPQRSTUVXWYZabcdefghijklmnñopqrstuvxwyzÁÉÍÓÚáéóíú0123456789."] intoString:&result];
	
	if ([result length] == [text length]){
		return YES;
	}
	return NO;
}

+(BOOL) isNotEmpty:(NSString *)text
{
	if ((text != nil)&&([text compare:@""]!=NSOrderedSame)) {
		return TRUE;
	}
	return FALSE;
	
	
}



+(BOOL) hasOnlyWhitespace:(NSString *)text
{
	NSScanner *scan = [[[NSScanner alloc] initWithString:text] autorelease];
	
	NSString *result = nil;
	
	[scan scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&result];
	
	if ([result length] == [text length]){
		return YES;
	}
	return NO;
}



+(BOOL) validateMail:(NSString *)text
{

	// validar dominio correcto
	NSRange rng = [text rangeOfString:[NSString stringWithFormat:@"."]];
	if(rng.length <= 0 || ([text length]-1) - rng.location < 2) {
		return NO;
	}
	return YES;
	
}

+ (NSDictionary *)getAppPlist {
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [path stringByAppendingPathComponent:@"MING_iPad-Info.plist"];
	
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:finalPath];
	return dic;
	
}

+ (NSString *) makeStringSendable:(NSString *)input
{
	//input = [input stringByReplacingOccurrencesOfString:@"á" withString:@"a"];
	//input = [input stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
	//input = [input stringByReplacingOccurrencesOfString:@"í" withString:@"i"];
	//input = [input stringByReplacingOccurrencesOfString:@"ó" withString:@"o"];
	//input = [input stringByReplacingOccurrencesOfString:@"ú" withString:@"u"];
	
	input = [input stringByReplacingOccurrencesOfString:@"/" withString:@""];
	input = [input stringByReplacingOccurrencesOfString:@"&" withString:@""];
	//input = [input stringByReplacingOccurrencesOfString:@"-" withString:@""];
	//input = [input stringByReplacingOccurrencesOfString:@"(" withString:@""];
	//input = [input stringByReplacingOccurrencesOfString:@")" withString:@""];
	//input = [input stringByReplacingOccurrencesOfString:@"." withString:@""];
	//input = [input stringByReplacingOccurrencesOfString:@"," withString:@""];
	
	return input;
}

+ (UIColor *)UIColorFromRGB:(NSString *)rgbStrValue {
	
	int rgbValue = 0;
	sscanf([rgbStrValue UTF8String], "%x", &rgbValue);
	return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+ (NSString *)stringWithEscapes:(NSString *)str {
    NSString *escapedString = [str stringByReplacingOccurrencesOfString:@"&"  withString:@"&amp;"];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"'"  withString:@"&#x27;"];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@">"  withString:@"&gt;"];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"<"  withString:@"&lt;"];
    
    return escapedString;
    //return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
