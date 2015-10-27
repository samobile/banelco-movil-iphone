//
//  WS_RealizarTransferenciaPropia.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cuenta.h"
#import "WSRequest.h"

@interface WS_RealizarTransferenciaPropia : WSRequest {
	
	NSString *userToken;
	Cuenta *cuentaOrigen;
	Cuenta *cuentaDestino;
	NSString *importe;
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) Cuenta *cuentaOrigen;
@property (nonatomic, retain) Cuenta *cuentaDestino;
@property (nonatomic, retain) NSString *importe;

@end
