//
//  CargaSUBEImporteController.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import "CuentasList.h"

@class Empresa;

@interface CargaSUBEImporteController : WheelAnimationController <UITextFieldDelegate,UIPickerViewDelegate> {

	IBOutlet UITextField *importe;
	IBOutlet UIButton *botonImporte;
	
	IBOutlet UIButton *botonSaldo;
	IBOutlet UIButton *botonContinuar;
	
	NSString *titulo;
	Empresa *empresa;
	NSString *idCliente;
	NSString *descCliente;
	NSString *empresaId;
	
	// Control Precios
	UIPickerView* precios;

	// Control Cuentas
	IBOutlet UITextField *textCuenta;
	IBOutlet UIButton *botonCuenta;
	IBOutlet UIButton *borrarCuenta;
	UIPickerView* cuentas;
	UIToolbar *ut;
	
	UIImageView* barTeclado;
	UIButton* barTecladoButton;
	
	IBOutlet UILabel *limporte;
	IBOutlet UILabel *lpeso;
	IBOutlet UILabel *lcuenta;
	
}

@property(nonatomic,retain) UIButton* barTecladoButton;
@property(nonatomic,retain) UIImageView* barTeclado;

@property (nonatomic, retain) IBOutlet UITextField *importe;
@property (nonatomic, retain) IBOutlet UIButton *botonImporte;

@property (nonatomic, retain) IBOutlet UIButton *botonSaldo;
@property (nonatomic, retain) IBOutlet UIButton *botonContinuar;

@property (nonatomic, retain) NSString *titulo;
@property (nonatomic, retain) Empresa *empresa;
@property (nonatomic, retain) NSString *idCliente;
@property (nonatomic, retain) NSString *descCliente;

@property (nonatomic, retain) NSString *empresaId;

@property (nonatomic, retain) UIPickerView* precios;

@property (nonatomic,retain) IBOutlet UIButton *botonCuenta;
@property (nonatomic,retain) IBOutlet UIButton *borrarCuenta;
@property (nonatomic,retain) IBOutlet UITextField *textCuenta;
@property (nonatomic, retain) UIPickerView* cuentas;
@property (nonatomic, retain) UIToolbar* ut;

@property (nonatomic, retain) IBOutlet UILabel *limporte;
@property (nonatomic, retain) IBOutlet UILabel *lpeso;
@property (nonatomic, retain) IBOutlet UILabel *lcuenta;

- (IBAction)continuar;
- (IBAction)selectCuenta:(id)sender;
- (IBAction)selectPrecio:(id)sender;
- (IBAction)borrar:(id)sender;

@end
