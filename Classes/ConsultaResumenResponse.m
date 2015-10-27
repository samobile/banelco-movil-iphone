//
//  ConsultaResumenResponse.m
//  BanelcoMovilIphone
//
//  Created by Demian on 9/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConsultaResumenResponse.h"


@implementation ConsultaResumenResponse

@synthesize fecha,saldo,listaDeMovimientos;



-(void) dealloc{
	
	[fecha release];
	[saldo release];
	[listaDeMovimientos release];
	
	[super dealloc];
}






@end
