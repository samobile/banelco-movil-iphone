//
//  TransferenciasEjecutar.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "Transfer.h"
#import "Cotizacion.h"
#import "WheelAnimationController.h"
#import "CustomDetail.h"

@interface TransferenciasEjecutar : CustomDetail {
	Transfer *transfer;
	Cotizacion *cotizacion;
	
	IBOutlet UIButton *botonAceptar;
	
	NSString *importeOrigen;
	NSString *importeDest;
	
}

@property (nonatomic, retain) Transfer *transfer;
@property (nonatomic, retain) Cotizacion *cotizacion;

@property (nonatomic, retain) IBOutlet UIButton *botonAceptar;

@property (nonatomic, retain) NSString *importeOrigen;
@property (nonatomic, retain) NSString *importeDest;


- (id) initWithTitle:(NSString *)t;

- (IBAction)aceptar;

@end
