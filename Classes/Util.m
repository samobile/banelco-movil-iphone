//
//  Util.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Util.h"
#import "Context.h"
#import "KeychainItemWrapper.h"


@implementation Util

/*+ (NSString *) getSecurityToken:(NSString *)codigoBanco forDni:(NSString *)dni {
	
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString* tokenString = (NSString*)[prefs objectForKey:
										[NSString stringWithFormat:
										 @"tokenSeguridad%@_%@",codigoBanco,dni]];
	
	if (!tokenString){
		tokenString = @"0";
	}
	
	return tokenString;
}

+ (void) setSecurityToken:(NSString *)token forBank:(NSString *)codigoBanco andDni:(NSString *)dni {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:token forKey:[NSString stringWithFormat:
								   @"tokenSeguridad%@_%@",codigoBanco,dni]];
	[prefs synchronize];
	
}*/

+ (NSString *) getSecurityToken:(NSString *)codigoBanco forDni:(NSString *)dni {
	
	KeychainItemWrapper *tokenItem = [[KeychainItemWrapper alloc] 
									  initWithIdentifier:[NSString stringWithFormat:@"token__%@_%@", codigoBanco, dni] 
									  accessGroup:nil];
	
	NSString *tokenString = (NSString *)[tokenItem objectForKey:(id)kSecValueData];
	
	if (!tokenString || [tokenString length] == 0) {
		//[tokenItem deleteKeychainItem];
		tokenString = @"0";
	}
	
	return tokenString;
}

+ (void) setSecurityToken:(NSString *)token forBank:(NSString *)codigoBanco andDni:(NSString *)dni {
	
	KeychainItemWrapper *tokenItem = [[KeychainItemWrapper alloc] 
									  initWithIdentifier:[NSString stringWithFormat:@"token__%@_%@", codigoBanco, dni] 
									  accessGroup:nil];

	[tokenItem setObject:token forKey:(id)kSecValueData];
		
}

+ (void) deleteSecurityTokenforBank:(NSString *)codigoBanco andDni:(NSString *)dni {
	
	KeychainItemWrapper *tokenItem = [[KeychainItemWrapper alloc]
									  initWithIdentifier:[NSString stringWithFormat:@"token__%@_%@", codigoBanco, dni]
									  accessGroup:nil];
	
	[tokenItem deleteKeychainItem];
    
}

+ (NSString *)aplicarMascara:(NSString*)str yMascara:(NSString*)mask {
	
	
	NSLog(@"Me llega la mascara = %@ ",mask);
	Context* context = [Context sharedContext];
	NSLog(@"Voy a usar la que esta en el contexto = %@ ", [context.mascaraCuentas valueForKey:context.banco.idBanco]);
	mask = [context.mascaraCuentas valueForKey:context.banco.idBanco];
	int idxStr = 0;
	if (!mask) {
		return [NSString stringWithString:str];
	}
	if(!str){
		return nil;
	}
	
	int idxMascara = [mask length] - [str length];
	
	NSString *result = [NSString stringWithString:str];
	
	while ((idxStr < [str length]) && (idxMascara<[mask length])) {
		
		if((idxMascara >=0) && ([mask characterAtIndex:idxMascara] == 'X')){
			NSRange range = NSMakeRange (idxStr, 1);
			result = [result stringByReplacingCharactersInRange:range withString:@"X"];
		}
		idxMascara++;
		idxStr++;
		
	}
	return result;
	
}

+ (void) handleError:(NSError *)error {

	

}

+ (NSString *) validPassword:(NSString *)pass withDni:(NSString *)dni {
	NSString* message = nil;
	
	int c3 = 1;
	int sa = 1; // secuencia ascendentes
	int sd = 1; // secuencias descendentes.
	int cantPermitida = 3;
	
	int digito1;
	int digito2;
	
	for (int i=0; i<6; i++) {
		digito1 =[pass characterAtIndex:i];
		digito2 =[pass characterAtIndex:i+1];
		
		if (digito1+1 == digito2){
			sa++;
		}
		if (digito1 == digito2+1){
			sd++;
		}
		if (digito1 == digito2){
			c3++;
		}
		
	}
	
	NSRange aRange = [pass rangeOfString:dni];
	NSRange bRange = [dni rangeOfString:pass];
    
    BOOL rep = [[pass substringToIndex:4]isEqualToString:[pass substringFromIndex:4]];
	
	if ((c3 > cantPermitida) || (sa > cantPermitida) || (sd > cantPermitida) || (aRange.location != NSNotFound) || (bRange.location != NSNotFound) || rep){
		
		message = @"Ingresá otra clave.  Recordá que la misma no debe ser asociable a tu número de documento, no debe repetir caracteres, ni estar conformada por secuencias ascendentes o descendentes.";
	}
	
	return message;
	
}


+ (NSString *) formatDigits:(NSString *)number {

	Context *context = [Context sharedContext];
	NSString *text = [number substringFromIndex:[number length] - 4];
	
	return [context.specialDigits stringByAppendingString:text];

}

/*+ (NSString *) soloNumeros:(NSString *)strImporte {

	NSMutableString *ms = [[NSMutableString]];
	
	for (int i=0; i < [strImporte length]; i++) {
		if ([strImporte characterAtIndex:i] >= '0' && [strImporte characterAtIndex:i] <= '0') {
			<#statements#>
		}
	}

}*/


//para mostrar un float con dos decimales, siempre.
+(NSString*) formatSaldo:(NSString*) saldo{
	NSString* resultado = [saldo stringByReplacingOccurrencesOfString:@"," withString:@"."];
	resultado = [NSString stringWithFormat: @"%.2f", [resultado floatValue]];
	resultado = [resultado stringByReplacingOccurrencesOfString:@"." withString:@","];
	return resultado;
	
}

//para mostrar un float con dos decimales, siempre.
+(NSString*) formatSaldoB:(NSString*) saldo{
    NSString* resultado = [saldo stringByReplacingOccurrencesOfString:@"," withString:@"."];
   
    NSNumberFormatter* nf = [[NSNumberFormatter alloc]init];
    [nf setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"es_AR"] autorelease]];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    nf.currencySymbol = @"";
    resultado = [nf stringFromNumber:[NSNumber numberWithFloat:[resultado floatValue]]];
    
    [nf release];

    //resultado = [resultado stringByReplacingOccurrencesOfString:@"$" withString:@""];
    return resultado;
    
}

//Para ir mostrando en tiempo real como quedara formateado.
+(NSString*) formatInput:(NSString*) input{
	//float inputF = [input floatValue]/ 100;
	float inputF = [input floatValue];
	NSMutableString* resultado =  [NSString stringWithFormat: @"%.2f", inputF];
	resultado = [resultado stringByReplacingOccurrencesOfString:@"." withString:@","];
	return resultado;
}

+ (NSString *)formatImporte:(NSString *)imp appendingValue:(NSString *)value {
	
	NSString *actual;
	if ([value isEqualToString:@""]) {
		
		actual = [[imp substringToIndex:[imp length]-1] stringByReplacingOccurrencesOfString:@"," withString:@""];
		if ([actual length] < 3) {
			actual = [NSString stringWithFormat:@"0%@",actual];
		}
	}
	else {
		actual = [[imp stringByAppendingFormat:@"%@",value] stringByReplacingOccurrencesOfString:@"," withString:@""];
	}
	
	NSString *m = [[actual substringToIndex:[actual length]-2] stringByAppendingFormat:@",%@",[actual substringFromIndex:[actual length]-2]];
	int idx = 0;
	for (int i = 0; i < [m length] - 1; i++) {
		if ([m characterAtIndex:i] == '0' && [m characterAtIndex:i+1] != ',') {
			idx = i+1;
		}
		else {
			break;
		}
	}
	return [m substringFromIndex:idx];	
}

+ (NSString *)formatCreditCardNumber:(NSString *)number {
	
	NSMutableString *num = [[NSMutableString alloc] init];
	
	for (int i = 0; i < 4; i++) {
		[num appendFormat:@"."];
	}
	
	for (int i = [number length]-4; i < [number length]; i++) {
		[num appendFormat:@"%c",[number characterAtIndex:i]];
	}
	return num;
	
}

+ (NSString *)decode:(NSString *)text {

	text = [text stringByReplacingOccurrencesOfString:@"*a" withString:@"á"];
	text = [text stringByReplacingOccurrencesOfString:@"*e" withString:@"é"];
	text = [text stringByReplacingOccurrencesOfString:@"*i" withString:@"í"];
	text = [text stringByReplacingOccurrencesOfString:@"*o" withString:@"ó"];
	text = [text stringByReplacingOccurrencesOfString:@"*u" withString:@"ú"];
	text = [text stringByReplacingOccurrencesOfString:@"*n" withString:@"ñ"];
    text = [text stringByReplacingOccurrencesOfString:@"*A" withString:@"Á"];
	text = [text stringByReplacingOccurrencesOfString:@"*E" withString:@"É"];
	text = [text stringByReplacingOccurrencesOfString:@"*I" withString:@"Í"];
	text = [text stringByReplacingOccurrencesOfString:@"*O" withString:@"Ó"];
	text = [text stringByReplacingOccurrencesOfString:@"*U" withString:@"Ú"];
	text = [text stringByReplacingOccurrencesOfString:@"*N" withString:@"Ñ"];
	text = [text stringByReplacingOccurrencesOfString:@"*1" withString:@"'"];
	text = [text stringByReplacingOccurrencesOfString:@"*2" withString:@"?"];
	text = [text stringByReplacingOccurrencesOfString:@"*3" withString:@"¿"];
	return text;

}

+ (NSString *)decodeISO8859:(NSString *)text {
	
	text = [text stringByReplacingOccurrencesOfString:@"&aacute;" withString:@"á"];
	text = [text stringByReplacingOccurrencesOfString:@"&eacute;" withString:@"é"];
	text = [text stringByReplacingOccurrencesOfString:@"&iacute;" withString:@"í"];
	text = [text stringByReplacingOccurrencesOfString:@"&oacute;" withString:@"ó"];
	text = [text stringByReplacingOccurrencesOfString:@"&uacute;" withString:@"ú"];
	text = [text stringByReplacingOccurrencesOfString:@"&ntilde;" withString:@"ñ"];
	return text;
	
}


// Seguridad

/*+ (NSString *) md5:(NSString *)str {
	
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
	
}*/



@end
