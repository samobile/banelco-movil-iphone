//
//  TransferenciasADesc.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 26/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "Cuenta.h"

@interface TransferenciasADesc : StackableScreen <UITextFieldDelegate> {
	IBOutlet UITextField *descripcionText;
	IBOutlet UIButton *botonAceptar;
	IBOutlet UILabel *lDescripcion;
	
	Cuenta *cuentaCBU;
}

@property (nonatomic, retain) IBOutlet UITextField *descripcionText;
@property (nonatomic, retain) IBOutlet UIButton *botonAceptar;
@property (nonatomic, retain) Cuenta *cuentaCBU;
@property (nonatomic, retain) IBOutlet UILabel *lDescripcion;

- (IBAction) aceptar;

@end
