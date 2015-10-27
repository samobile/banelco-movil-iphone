//
//  CreditCardResumen.h
//  BanelcoMovil
//
//  Created by German Levy on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface CreditCardResumen : NSObject {

	NSString * minAPagarPesos;

	NSString * totalAPagarPesos;

	NSString * minAPagarDolares;

	NSString * nroTarjeta;

	NSString * fechaVencimiento;

	NSString * totalAPagarDolares;
	
}

@property (nonatomic, retain) NSString * minAPagarPesos;

@property (nonatomic, retain) NSString * totalAPagarPesos;

@property (nonatomic, retain) NSString * minAPagarDolares;

@property (nonatomic, retain) NSString * nroTarjeta;

@property (nonatomic, retain) NSString * fechaVencimiento;

@property (nonatomic, retain) NSString * totalAPagarDolares;

+ (CreditCardResumen *) getResumenWithNumber:(NSString *)number;

//+ (NSArray *) getResumenes:(NSString *)token;

@end
