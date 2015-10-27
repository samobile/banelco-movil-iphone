//
//  CargaCelularImporte.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import "CuentasList.h"

@class Empresa;

@interface CargaCelularImporteController : WheelAnimationController <UITextFieldDelegate,UIPickerViewDelegate,UIActionSheetDelegate> {
	
	IBOutlet UITextField *importe;
	
	IBOutlet UIButton *botonSaldo;
	IBOutlet UIButton *botonContinuar;
	
	NSString *titulo;
	Empresa *empresa;
	NSString *idCliente;
	NSString *descCliente;
	NSString *empresaId;
	
	//Control Cuentas
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
    
    
    IBOutlet UIView *infoContainer;
    IBOutlet UILabel *operadorLbl;
    IBOutlet UILabel *carrierLbl;
    IBOutlet UIButton *otroBtn;
    IBOutlet UILabel *ceroLbl;
    IBOutlet UILabel *quinceLbl;
    IBOutlet UITextField *codTf;
    IBOutlet UITextField *nroTf;
    NSMutableArray *importesList;
    UIToolbar *importeToolBar;
    BOOL cuentasPicker;
    int carrierSeleccionado;
    UIActionSheet *subMenuCarrier;
    NSMutableDictionary *importesDict;
    
    NSMutableDictionary *empresasRecarga;
	
}

@property (nonatomic, retain) UIView *infoContainer;
@property (nonatomic, retain) UILabel *operadorLbl;
@property (nonatomic, retain) UILabel *carrierLbl;
@property (nonatomic, retain) UIButton *otroBtn;
@property (nonatomic, retain) UILabel *ceroLbl;
@property (nonatomic, retain) UILabel *quinceLbl;
@property (nonatomic, retain) UITextField *codTf;
@property (nonatomic, retain) UITextField *nroTf;
@property (nonatomic, retain) NSMutableArray *importesList;
@property (nonatomic, retain) UIToolbar *importeToolBar;
@property int carrierSeleccionado;
@property (nonatomic, retain) UIActionSheet *subMenuCarrier;

@property(nonatomic,retain) UIButton* barTecladoButton;
@property(nonatomic,retain) UIImageView* barTeclado;

@property (nonatomic, retain) IBOutlet UITextField *importe;
@property (nonatomic, retain) IBOutlet UIButton *botonSaldo;
@property (nonatomic, retain) IBOutlet UIButton *botonContinuar;

@property (nonatomic, retain) NSString *titulo;
@property (nonatomic, retain) Empresa *empresa;
@property (nonatomic, retain) NSString *idCliente;
@property (nonatomic, retain) NSString *descCliente;

@property (nonatomic, retain) NSString *empresaId;

@property (nonatomic,retain) IBOutlet UIButton *botonCuenta;
@property (nonatomic,retain) IBOutlet UIButton *borrarCuenta;
@property (nonatomic,retain) IBOutlet UITextField *textCuenta;
@property (nonatomic, retain) UIPickerView* cuentas;
@property (nonatomic, retain) UIToolbar* ut;

@property (nonatomic, retain) IBOutlet UILabel *limporte;
@property (nonatomic, retain) IBOutlet UILabel *lpeso;
@property (nonatomic, retain) IBOutlet UILabel *lcuenta;

@property (nonatomic, retain) NSMutableDictionary *importesDict;
@property (nonatomic, retain) NSMutableDictionary *empresasRecarga;

- (IBAction)continuar;
- (IBAction)selectCuenta:(id)sender;
- (IBAction)borrar:(id)sender;
-(IBAction)cambiarCarrier;
@end
