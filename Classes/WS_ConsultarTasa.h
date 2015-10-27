//
//  WS_ConsultarTasa.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"

@interface WS_ConsultarTasa : WSRequest {
	
	NSString *userToken;
	NSString *importe;
	NSString *plazo;
	
	NSString *numCuentaPlazo;
	NSString *numCuenta;
	NSString *codTipoCta;
	int codMoneda;
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *importe;
@property (nonatomic, retain) NSString *plazo;
@property (nonatomic, retain) NSString *numCuentaPlazo;
@property (nonatomic, retain) NSString *numCuenta;
@property (nonatomic, retain) NSString *codTipoCta;
@property int codMoneda;

@end