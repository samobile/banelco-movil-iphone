//
//  EmpresaClienteId.h
//  BanelcoMovil
//
//  Created by German Levy on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Empresa.h"

@interface EmpresaClienteId : NSObject {

	Empresa * empresa;

	NSString * clienteId;

	int nroSecuencia;
	
}

@property (nonatomic, retain) Empresa * empresa;

@property (nonatomic, retain) NSString * clienteId;

@property int nroSecuencia;


@end
