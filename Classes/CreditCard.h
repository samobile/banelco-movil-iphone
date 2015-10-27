//
//  CreditCard.m
//
//  Created by German Levy on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreditCardDisponibles.h"
#import "GDataXMLNode.h"


@interface CreditCard : NSObject {

	NSString * codigo;

	NSString * numero;

	NSString * disponibleAdelanto;

	NSString * fechaVencimiento;

	NSString * nombre;

	NSString * saldoPesos;

	NSString * pagoMinimo;

	NSString * saldoDolares;
    
    NSString * fechaProxCierre;
    
    NSString * fechaProxVenc;
    
    NSString * fechaCierreActual;
	
}

@property (nonatomic, retain) NSString * codigo;

@property (nonatomic, retain) NSString * numero;

@property (nonatomic, retain) NSString * disponibleAdelanto;

@property (nonatomic, retain) NSString * fechaVencimiento;

@property (nonatomic, retain) NSString * nombre;

@property (nonatomic, retain) NSString * saldoPesos;

@property (nonatomic, retain) NSString * pagoMinimo;

@property (nonatomic, retain) NSString * saldoDolares;

@property (nonatomic, retain) NSString * fechaProxCierre;

@property (nonatomic, retain) NSString * fechaProxVenc;

@property (nonatomic, retain) NSString * fechaCierreActual;

+ (CreditCard *) parseCreditCard:(GDataXMLElement *)creditCard;
+ (NSMutableArray *) parseCreditCards:(GDataXMLElement *)creditCardsSoap;
+ (NSMutableArray *) parseCreditCardsVisa:(GDataXMLElement *)creditCardsSoap;
+ (CreditCard *) parseCreditCardVisa:(GDataXMLElement *)creditCard;
+ (NSArray *) getSaldo:(NSString *)token;
+ (NSArray *) getVisas:(NSString *)token;
+ (CreditCardDisponibles *) getDisponibles:(NSString *)token;
+ (CreditCardDisponibles *) getDisponibles:(NSString *)token withNumber:(NSString *)number;

@end
