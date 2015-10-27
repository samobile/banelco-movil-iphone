//
//  CommonFunctions.m
//  SyncService
//
//  Created by Federico Lanzani on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CommonFunctions.h"
#import "GDataXMLNode.h"
#import "NSData64baseString.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation CommonFunctions

+ (NSString *) cleanResponseXML:(NSString *)xml {
	
	NSString *cleaned = [xml stringByReplacingOccurrencesOfString:@"ns1:" withString:@""];
	
	cleaned = [cleaned stringByReplacingOccurrencesOfString:@"ns2:" withString:@""];
	
	cleaned = [cleaned stringByReplacingOccurrencesOfString:@"xsi:" withString:@""];
	
	return cleaned;
	
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
		//return xml;
        return nil;
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
		
		NSString *formatted = [NSString stringWithFormat:@"%@",[p stringFromDate:val]];
		return formatted;
	}
}

+  (NSString *) dateToNSStringCache:(NSDate *)val
{
	if (val ==nil) {
		return [NSString stringWithFormat:@""];
	}
	else
	{
		NSDateFormatter *p = [[[NSDateFormatter alloc] init] autorelease];
		
        //setea locale en en_GB para obtener siempre fecha en formato de 24hs
        NSLocale* formatterLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        [p setLocale:formatterLocale];
        [formatterLocale release];
        
        [p setDateFormat:@"yyyyMMddhhmmss"];
		
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
		return @"yyyyMMddhhmmss";
	
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

+ (NSString *) WSFormatTarjeta
{
	return @"MM/yyyy";
	
}

+ (NSString *) BEWSFormat
{
	return @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
	
}

+ (NSString *) NSDecimalNumberToNSString:(NSDecimalNumber *)val
{
	if (val==nil) {
		return [NSString stringWithFormat:@"",val];
	}
	else {
		return [NSString stringWithFormat:@"%@",val];
	}
}



+  (NSDate *) NSStringToNSDate:(NSString *)val withFormat:(NSString *)format
{

	NSDateFormatter *p = [[[NSDateFormatter alloc] init] autorelease];
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
	
	NSScanner *scan = [[NSScanner alloc] initWithString:text];
	
	NSString *result = [[NSString alloc] init];
	
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
	
	NSScanner *scan = [[NSScanner alloc] initWithString:text];
	
	NSString *result = [[NSString alloc] init];
	
	[scan scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789,"] intoString:&result];
	
	if ([result length] == [text length]){
		return YES;
	}
	return NO;
}


+(BOOL) hasOnlyAlphabet:(NSString *)text
{
	NSScanner *scan = [[NSScanner alloc] initWithString:text];
	
	NSString *result = [[NSString alloc] init];
	
	[scan scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNÑOPQRSTUVXWYZabcdefghijklmnñopqrstuvxwyzÁÉÍÓÚáéóíú"] intoString:&result];
	
	if ([result length] == [text length]){
		return YES;
	}
	return NO;
}

+(BOOL) hasAlphabet:(NSString *)text
{
    
	NSScanner *scan = [[NSScanner alloc] initWithString:text];
	
	NSString *result = [[NSString alloc] init];
	
    [scan scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNÑOPQRSTUVXWYZabcdefghijklmnñopqrstuvxwyzÁÉÍÓÚáéóíú"] intoString:&result];
	
	if ([result length] > 0){
		return YES;
	}
	return NO;
}

+(BOOL) hasNumeric:(NSString *)text
{
	NSScanner *scan = [[NSScanner alloc] initWithString:text];
	
	NSString *result = [[NSString alloc] init];
    
    [scan scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVXWYZabcdefghijklmnopqrstuvxwyz0123456789"] intoString:&result];
	
    [scan scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] intoString:&result];
	
	if ([result length] > 0){
		return YES;
	}
	return NO;
}

+ (BOOL)hasNumbersAndLetters:(NSString *)text {
    
    NSString *newString = [[text componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
    if ([newString length] > 0) {
        newString = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet letterCharacterSet]] componentsJoinedByString:@""];
    }
    return [newString length] > 0;
}

+(BOOL) hasAlphabetAndSpecial:(NSString *)text
{
	NSScanner *scan = [[NSScanner alloc] initWithString:text];
	
	NSString *result = [[NSString alloc] init];
	
	[scan scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNÑOPQRSTUVXWYZabcdefghijklmnñopqrstuvxwyzÁÉÍÓÚáéóíú_-.0123456789"] intoString:&result];
	
	if ([result length] == [text length]){
		return YES;
	}
	return NO;
}

+(BOOL) hasAlphaNumeric:(NSString *)text
{
	NSScanner *scan = [[NSScanner alloc] initWithString:text];
	
	NSString *result = [[NSString alloc] init];
	
	[scan scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVXWYZabcdefghijklmnopqrstuvxwyz0123456789"] intoString:&result];
	
	if ([result length] == [text length]){
		return YES;
	}
	return NO;
}

+(BOOL) hasAlphabetAndNumbers:(NSString *)text
{
	NSScanner *scan = [[NSScanner alloc] initWithString:text];
	
	NSString *result = [[NSString alloc] init];
	
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
	NSScanner *scan = [[NSScanner alloc] initWithString:text];
	
	NSString *result = [[NSString alloc] init];
	
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
	NSLog(finalPath);
	NSArray *contentArray = [NSArray arrayWithContentsOfFile:finalPath];
	
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

+ (CGRect)frame4inchDisplay:(CGRect)f {
    return CGRectMake(f.origin.x, f.origin.y, f.size.width, IPHONE5_HDIFF(f.size.height));
}

+ (NSString *)validateStrongPassword:(NSString *)password {
    
    //return @"test";
    
    if ([password isEqualToString:@"00000000"] ||
        [password isEqualToString:@"11111111"] ||
        [password isEqualToString:@"22222222"] ||
        [password isEqualToString:@"33333333"] ||
        [password isEqualToString:@"44444444"] ||
        [password isEqualToString:@"55555555"] ||
        [password isEqualToString:@"66666666"] ||
        [password isEqualToString:@"77777777"] ||
        [password isEqualToString:@"88888888"] ||
        [password isEqualToString:@"99999999"])
    {
        NSLog(@"La contraseña no puede contener todos los números iguales.");
        return @"La contraseña no puede contener todos los números iguales.";
    }
    
    if ([password isEqualToString:@"01234567"] ||
        [password isEqualToString:@"12345678"] ||
        [password isEqualToString:@"23456789"] ||
        [password isEqualToString:@"34567890"] ||
        [password isEqualToString:@"45678901"] ||
        [password isEqualToString:@"56789012"] ||
        [password isEqualToString:@"67890123"] ||
        [password isEqualToString:@"78901234"] ||
        [password isEqualToString:@"89012345"] ||
        [password isEqualToString:@"90123456"] ||
        [password isEqualToString:@"98765432"] ||
        [password isEqualToString:@"87654321"] ||
        [password isEqualToString:@"76543210"] ||
        [password isEqualToString:@"65432109"] ||
        [password isEqualToString:@"54321098"] ||
        [password isEqualToString:@"43210987"] ||
        [password isEqualToString:@"32109876"] ||
        [password isEqualToString:@"21098765"] ||
        [password isEqualToString:@"10987654"] ||
        [password isEqualToString:@"09876543"])
    {
        NSLog(@"La contraseña no pueden ser secuencias ascendentes o descendentes.");
        return @"La contraseña no pueden ser secuencias ascendentes o descendentes.";
    }
    
    if ([[password substringToIndex:4] isEqualToString:[password substringFromIndex:4]]) {
        NSLog(@"1 - La contraseña no puede contener series repetidas de números.");
        return @"La contraseña no puede contener series repetidas de números.";
    }
    
    int i = 0;
    int p = 0;
    int c3 = 1;
    int a = 0;
    int sa = 1;
    int sd = 1;
    int ant = 0;
    if (p == 0)
    {
        for (i = 0; i < [password length]; i++)
        {
            a = [[password substringWithRange:NSMakeRange(i, 1)] intValue];
            if (a == ant)
            {
                if (++c3 > 3)
                {
                    NSLog(@"2 - La contraseña no puede contener series repetidas de números.");
                    return @"La contraseña no puede contener series repetidas de números.";
                }
            }
            else
            {
                c3 = 1;
                if (ant == a - 1)
                {
                    if (++sa > 3)
                    {
                        NSLog(@"3 - La contraseña no puede contener series repetidas de números.");
                        return @"La contraseña no puede contener series repetidas de números.";
                    }
                    sd = 1;
                }
                else
                {
                    if (ant == a + 1)
                    {
                        if (++sd > 3)
                        {
                            NSLog(@"4 - La contraseña no puede contener series repetidas de números.");
                            return @"La contraseña no puede contener series repetidas de números.";
                        }
                        sa = 1;
                    }
                    else
                    {
                        sa = 1;
                        sd = 1;
                    }
                }
            }
            
            ant = a;
        }
    }
    
    return nil;
}

+ (NSString *)numberToSpeechString:(NSString *)str {
    
    if (![CommonFunctions hasNumbers:str]) {
        return str;
    }
    
    // we want to know if a character is a number or not
    NSCharacterSet *numberCharacters = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    // we use this formatter to spell out individual numbers
    NSNumberFormatter *spellOutSingleNumber = [NSNumberFormatter new];
    spellOutSingleNumber.numberStyle = NSNumberFormatterSpellOutStyle;
    
    NSMutableArray *spelledOutComonents = [NSMutableArray array];
    // loop over the phone number add add the accessible variants to the array
    [str enumerateSubstringsInRange:NSMakeRange(0, str.length)
                                    options:NSStringEnumerationByComposedCharacterSequences
                                 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                     // check if it's a number
                                     if ([substring rangeOfCharacterFromSet:numberCharacters].location != NSNotFound) {
                                         // is a number
                                         NSNumber *number = @([substring integerValue]);
                                         [spelledOutComonents addObject:[spellOutSingleNumber stringFromNumber:number]];
                                     } else {
                                         // is not a number
                                         [spelledOutComonents addObject:substring];
                                         
                                         
                                     }
                                 }];
    // finally separate the components with spaces (so that the string doesn't become "ninefivesixfive".
    return [spelledOutComonents componentsJoinedByString:@", "];
}

+ (NSString *)replaceSymbolVoice:(NSString *)str {
    NSString *s = [str stringByReplacingOccurrencesOfString:@"u$s" withString:@"dolares "];
    s = [s stringByReplacingOccurrencesOfString:@"U$S" withString:@"dolares "];
    return [s stringByReplacingOccurrencesOfString:@"$" withString:@"pesos "];
}

+ (BOOL)isiPhone4S {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    if ([platform isEqualToString:@"iPhone4,1"]) {
        return YES;
    }
    return NO;
}

@end
