//
//  ListarEmpresas_WSRequest.h
//  BanelcoMovil
//
//  Created by German Levy on 8/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"


@interface WS_ListarEmpresas : WSRequest {

	NSString *userToken;
	NSString *rubro;
	NSString *busqueda;
	NSString *codBanco;
	NSNumber *pagina;
	NSNumber *soloConsulta;
	
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *rubro;
@property (nonatomic, retain) NSString *busqueda;
@property (nonatomic, retain) NSString *codBanco;
@property (nonatomic, retain) NSNumber *pagina;
@property (nonatomic, retain) NSNumber *soloConsulta;

@end
