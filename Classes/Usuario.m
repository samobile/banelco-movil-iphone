//
//  Usuario.m
//  BanelcoMovil_Prueba
//
//  Created by German Levy on 8/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Usuario.h"


@implementation Usuario

@synthesize firstLogin, fullname, needsPinChange, token, userName, viewTerminos;
@synthesize celular, operadorCelular;
@synthesize showVencim, showInfo, email;
@synthesize marcaVencim, marcaInfo;
@synthesize profile,vencimiento,ultimoLogin, nroDocumento, tipoDocumento;


-(id)init {

	self = [super init];
	if(self) {
		profile = @"R";
	}
	
	return self;

}

-(BOOL)esRestringido {

	if([profile isEqualToString:@"R"]) {
		return YES;
	} else {
		return NO;
	}

}

- (void)dealloc {
    self.tipoDocumento = nil;
    self.nroDocumento = nil;
    [super dealloc];
}

@end
