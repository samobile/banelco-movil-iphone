//
//  WS_ConsultarSaldos.h
//  BanelcoMovilIphone
//
//  Created by Demian on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"

@interface WS_ConsultarSaldos : WSRequest {
	
	NSString* userToken;
	NSString* numeroCuenta;
	int codigoTipoCuenta;
	int codigoMonedaCuenta;

}

@property(nonatomic,retain) NSString* userToken;
@property(nonatomic,retain) NSString* numeroCuenta;
@property int codigoTipoCuenta;
@property int codigoMonedaCuenta;


@end
