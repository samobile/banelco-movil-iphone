//
//  ExecutePagoTarjeta_Cuentas.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Empresa.h"


@interface ExecutePagoTarjeta_Cuentas : NSObject {

	Empresa *empresa;
	
	int nextAction;
	
}

@property (nonatomic, retain) Empresa *empresa;

- (void)execute;

@end
