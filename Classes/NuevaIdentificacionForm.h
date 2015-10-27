//
//  NuevaIdentificacionForm.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "Empresa.h"


@interface NuevaIdentificacionForm : StackableScreen <UITextFieldDelegate> {

	IBOutlet UITextField *txtNroTarjeta_CUIT;
	
	IBOutlet UITextField *txtCUIT_Generador;
	
	IBOutlet UILabel *labelEmpresa;
	
	IBOutlet UILabel *labelLeyenda;
	
	Empresa *empresa;
	
	NSString *leyenda; // Ingresada en caso que empresa.tipoPago == TIPO_PAGO_SIN_DEUDA_ADIC
	
	UIButton* blankButton;
	
	UIImageView* barTeclado;
	UIButton* barTecladoButton;
	
	IBOutlet UILabel *leyendaEmpresa;
	IBOutlet UILabel *lCUITCon;
	IBOutlet UILabel *lCUITGen;
	
	
}
@property(nonatomic,retain) UIButton* barTecladoButton;
@property(nonatomic,retain) UIImageView* barTeclado;

@property (nonatomic, retain) IBOutlet UITextField *txtNroTarjeta_CUIT;

@property (nonatomic, retain) IBOutlet UITextField *txtCUIT_Generador;

@property (nonatomic, retain) IBOutlet UILabel *labelEmpresa;

@property (nonatomic, retain) IBOutlet UILabel *labelLeyenda;

@property (nonatomic, retain) NSString *leyenda;

@property(nonatomic,retain) UIButton* blankButton;

@property (nonatomic, retain) IBOutlet UILabel *leyendaEmpresa;

@property (nonatomic, retain) IBOutlet UILabel *lCUITCon;
@property (nonatomic, retain) IBOutlet UILabel *lCUITGen;

- (IBAction) activarBoton ;
- (IBAction)continuar;

- (IBAction)dismissKeyboard:(id)sender;

- (void) moveScreenUp;
- (void) moveScreenDown;


@end
