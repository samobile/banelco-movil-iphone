//
//  Util.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Util : NSObject {

}

+ (NSString *) getSecurityToken:(NSString *)codigoBanco forDni:(NSString *)dni;

+ (void) setSecurityToken:(NSString *)token forBank:(NSString *)codigoBanco andDni:(NSString *)dni;

+ (void) deleteSecurityTokenforBank:(NSString *)codigoBanco andDni:(NSString *)dni;

+ (NSString *) validPassword:(NSString *)pass withDni:(NSString *)dni;

+ (NSString *) formatDigits:(NSString *)number;
+ (NSString *)aplicarMascara:(NSString*)str  yMascara:(NSString*)mask;



//para mostrar un float con dos decimales, siempre.
+ (NSString*) formatSaldo:(NSString*) saldo;
+(NSString*) formatSaldoB:(NSString*) saldo;
//Para ir mostrando en tiempo real como quedara formateado.
+ (NSString*) formatInput:(NSString*) input;

+ (NSString *)formatImporte:(NSString *)imp appendingValue:(NSString *)value;

+ (NSString *)formatCreditCardNumber:(NSString *)number;

+ (NSString *)decode:(NSString *)text;

+ (NSString *)decodeISO8859:(NSString *)text;

//+ (NSString *) md5:(NSString *)str;

@end
