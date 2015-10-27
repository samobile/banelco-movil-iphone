//
//  CreditCardCompra.h
//  BanelcoMovil
//
//  Created by German Levy on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Context.h"
#import "Util.h"


@interface CreditCardCompra : NSObject {

	NSString * nroTarjeta;
	NSString * valor;
	NSString * fechaCompra;
	NSString * concepto;
    NSString *dolares;
	
}

@property (nonatomic,retain) NSString * nroTarjeta;
@property (nonatomic,retain) NSString * valor;
@property (nonatomic,retain) NSString * fechaCompra;
@property (nonatomic,retain) NSString * concepto;
@property (nonatomic, retain) NSString *dolares;

+ (NSMutableArray *) getUltimasCompras:(NSString *)token withNumber:(NSString *)number;


@end
