//
//  WS_GenerarClave.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 5/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_GenerarClave : WSRequest {

	NSString *tipoDoc;
	NSString *nroDoc;
	NSString *codBanco;
	NSString *fechaNac;
	NSString *codCarrier;
	NSString *nroCel;
	NSString *nroTarjeta;
	NSString *fechaTarjeta;
	NSString *clave;
	NSString *userToken;
	
}

@property (nonatomic, retain) NSString *tipoDoc;
@property (nonatomic, retain) NSString *nroDoc;
@property (nonatomic, retain) NSString *codBanco;
@property (nonatomic, retain) NSString *fechaNac;
@property (nonatomic, retain) NSString *codCarrier;
@property (nonatomic, retain) NSString *nroCel;
@property (nonatomic, retain) NSString *nroTarjeta;
@property (nonatomic, retain) NSString *fechaTarjeta;
@property (nonatomic, retain) NSString *clave;
@property (nonatomic, retain) NSString *userToken;

@end
