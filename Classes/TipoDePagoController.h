//
//  TipoDePagoController.h
//  BanelcoMovilIphone
//
//	Esta clase engloba a TipoDePagoList, IngresarImporteForm y CuentasList
//	del proyecto J2ME
//
//  Created by German Levy on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "Deuda.h"
#import "CuentasList.h"


@interface TipoDePagoController : StackableScreen <UITextFieldDelegate, UIPickerViewDelegate> {

	Deuda *deuda;
	
	//IBOutlet UILabel *detalle;
	UIButton* blankButton;
	IBOutlet UIButton *btnTotal;
	UIImage *totalSelec;
	IBOutlet UIButton *btnOtro;
	UIImage *otroSelec;
	
	IBOutlet UITextField *tfPrecio;
	
	//sea
	//CuentasList *listaCuentas;
	//Control Cuentas
	IBOutlet UITextField *textCuenta;
	IBOutlet UIButton *botonCuenta;
	IBOutlet UIButton *borrarCuenta;
	UIPickerView* cuentas;
	UIToolbar *ut;
	
	
	//IBOutlet UITableView *listaCuentasView;
	
	BOOL importeTotal;
	
	IBOutlet UILabel *simbolo;
	
	UIImageView* barTeclado;
	UIButton* barTecladoButton;
	
	IBOutlet UILabel *lCuenta;
	
	
}
@property(nonatomic,retain) UIButton* barTecladoButton;
@property(nonatomic,retain) UIImageView* barTeclado;

@property (nonatomic, retain) Deuda *deuda;

//@property (nonatomic, retain) IBOutlet UILabel *detalle;

@property (nonatomic, retain) IBOutlet UIButton *btnTotal;
@property (nonatomic, retain) UIImage *totalSelec;
@property (nonatomic, retain) IBOutlet UIButton *btnOtro;
@property (nonatomic, retain) UIImage *otroSelec;

@property (nonatomic, retain) IBOutlet UITextField *tfPrecio;

@property (nonatomic, retain) CuentasList *listaCuentas;

//@property (nonatomic, retain) IBOutlet UITableView *listaCuentasView;

@property(nonatomic,retain) UIButton* blankButton;

@property BOOL importeTotal;

@property (nonatomic, retain) IBOutlet UILabel *simbolo;

//sea
@property (nonatomic,retain) IBOutlet UIButton *botonCuenta;
@property (nonatomic,retain) IBOutlet UIButton *borrarCuenta;
@property (nonatomic,retain) IBOutlet UITextField *textCuenta;
@property (nonatomic, retain) UIPickerView* cuentas;
@property (nonatomic, retain) UIToolbar* ut;

@property (nonatomic, retain) IBOutlet UILabel *lCuenta;

- (id)initWithDeuda:(Deuda *)ds forImporteTotal:(BOOL)importeTotal;

-(IBAction) activarBoton;
-(void) hideKeyboard;
- (IBAction)dismissKeyboard: (id)sender;

- (IBAction)bloquearPrecio;

- (IBAction)otroPrecio;

- (IBAction)consultarSaldo;

- (IBAction)continuar;

//sea
- (IBAction)selectCuenta:(id)sender;
- (IBAction)borrar:(id)sender;


@end
