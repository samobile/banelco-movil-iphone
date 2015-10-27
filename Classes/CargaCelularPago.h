//
//  CargaCelularPago.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "CustomDetail.h"

@class Empresa;
@class Cuenta;

@interface CargaCelularPago : CustomDetail {

	IBOutlet UIButton *botonPagar;
	
	NSString *importe;
	Empresa *empresa;
	NSString *idCliente;
	NSString *descCliente;
	
	Cuenta *selectedCuenta;

}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *processIndicator;
@property (nonatomic, retain) IBOutlet UIButton *botonPagar;

@property (nonatomic, retain) IBOutlet NSString *importe;
@property (nonatomic, retain) IBOutlet Empresa *empresa;
@property (nonatomic, retain) NSString *idCliente;
@property (nonatomic, retain) NSString *descCliente;
@property (nonatomic, retain) Cuenta *selectedCuenta;


- (void)iniciar;

-(IBAction)pagar;

@end
