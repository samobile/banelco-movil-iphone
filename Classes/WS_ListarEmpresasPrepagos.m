//
//  ListarEmpresasPrepago_WSRequest.m
//  BanelcoMovil
//
//  Created by German Levy on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ListarEmpresasPrepagos.h"
#import "Context.h"
#import "Usuario.h"
#import "CommonFunctions.h"
#import "Cuenta.h"


@implementation WS_ListarEmpresasPrepagos

@synthesize userToken, rubro, codBanco;

-(NSString *)getWSName {
	return @"listarEmpresasPrepagos";
}

-(NSMutableArray *)getSoapParams {
	return [NSArray arrayWithObjects:userToken, rubro, codBanco, nil];
}

-(id)parseResponse:(NSData *)data {
	
	// TODO	
	return nil;
	
}

@end
