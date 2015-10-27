//
//  BuscarEmpresa.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "Rubro.h"
#import "ZBarReaderViewController.h"

@class BanelcoReaderViewController, WaitingAlert;

@interface BuscarEmpresa : StackableScreen <UITextFieldDelegate,ZBarReaderDelegate> {

	IBOutlet UILabel *lblCampo;
	
	IBOutlet UITextField *campo;
	
	IBOutlet UIButton *btnRubros;
	
	int tipo;
	
	Rubro *rubro;
	
	NSString *codRubro;
	
	int tipoAccion; // Para lista de empresas
    
    IBOutlet UIButton *btnScan;
    
    BanelcoReaderViewController *scanReader;
	
    WaitingAlert *alert;
}

@property (nonatomic, retain) IBOutlet UILabel *lblCampo;

@property (nonatomic, retain) IBOutlet UITextField *campo;

@property (nonatomic, retain) IBOutlet UIButton *btnRubros;

@property (nonatomic, retain) UIButton *btnScan;

@property (nonatomic, retain) BanelcoReaderViewController *scanReader;

@property (nonatomic, retain) WaitingAlert *alert;

extern int const BE_INICIAL;
extern int const BE_LIMITE;
extern int const BE_INICIAL_COD;

- (id)initWithType:(int)_tipo tipoAccion:(int)accion andRubro:(Rubro *)_rubro;

- (IBAction)buscar;

- (IBAction)listarRubros;


@end
