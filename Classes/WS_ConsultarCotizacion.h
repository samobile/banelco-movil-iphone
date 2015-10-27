//
//  WS_ConsultarCotizacion.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ConsultarCotizacion : WSRequest {
	
	NSString *userToken;
	NSString *numeroCuenta;
	int codigoTipoCuenta;
	int codMonedaCuenta;
	NSString *importe;
	int codMonedaDest;
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *numeroCuenta;
@property int codigoTipoCuenta;
@property int codMonedaOrigen;
@property (nonatomic, retain) NSString *importe;
@property int codMonedaDest;

@end
