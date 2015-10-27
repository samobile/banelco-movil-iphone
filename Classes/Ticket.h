//
//  Ticket.h
//  BanelcoMovil
//
//  Created by German Levy on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GDataXMLNode.h"
#import "Util.h"

@interface Ticket : NSObject {

	NSString * fiid;

	NSString * bancoDestino;

	NSString * empresa;

	NSString * fechaPago;

	NSString * moneda;

	int nroSecuencia;

	NSString * nroTransaccion;

	NSString * cuenta;

	NSString * canal;

	NSString * cuentaDestino;

	NSString * clienteId;

	NSString * cbuDestino;

	NSString * nroControl;

	NSString * importe;
	
	//int PAGOS;
	
	//int TRANSFERENCIAS;
	
}

@property (nonatomic, retain) NSString * fiid;

@property (nonatomic, retain) NSString * bancoDestino;

@property (nonatomic, retain) NSString * empresa;

@property (nonatomic, retain) NSString * fechaPago;

@property (nonatomic, retain) NSString * moneda;

@property int nroSecuencia;

@property (nonatomic, retain) NSString * nroTransaccion;

@property (nonatomic, retain) NSString * cuenta;

@property (nonatomic, retain) NSString * canal;

@property (nonatomic, retain) NSString * cuentaDestino;

@property (nonatomic, retain) NSString * clienteId;

@property (nonatomic, retain) NSString * cbuDestino;

@property (nonatomic, retain) NSString * nroControl;

@property (nonatomic, retain) NSString * importe;

//@property int PAGOS;

//@property int TRANSFERENCIAS;

+ (Ticket *) parseTicketTransf:(GDataXMLElement *)soapObject;
+ (Ticket *) parseTicketPago:(GDataXMLElement *)soapObject nroSecuencia:(int)nroSecuencia;
- (NSString *) toString;
@end
