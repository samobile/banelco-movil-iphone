//
//  ExtraccionesImporte.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/8/15.
//
//

#import "StackableScreen.h"

@class Cuenta;

@interface ExtraccionesImporte : StackableScreen <UITextFieldDelegate,UIPickerViewDelegate,UIActionSheetDelegate> {
    IBOutlet UITextField *importe;
    IBOutlet UIButton *botonSaldo;
    IBOutlet UIButton *botonContinuar;
    
    //Control Cuentas
    IBOutlet UITextField *textCuenta;
    IBOutlet UIButton *botonCuenta;
    IBOutlet UIButton *borrarCuenta;
    UIPickerView* cuentas;
    UIToolbar *ut;
    
    UIView* barTeclado;
    
    IBOutlet UILabel *limporte;
    IBOutlet UILabel *lpeso;
    IBOutlet UILabel *lcuenta;
    IBOutlet UILabel *lTipoDoc;
    
    IBOutlet UIView *containerTercero;
    IBOutlet UITextField *dniTxt;
    
    Cuenta *selectedCuenta;
    
    BOOL extraTerceros;
    
    BOOL pickerInScreen;
    
    NSMutableArray *listaCuentas;
    
    UIActionSheet *subMenuDNI;
    UIButton *barTecladoButton;

    NSInteger tipoSeleccionado;
}

@property (nonatomic, retain) UITextField *importe;
@property (nonatomic, retain) UIButton *botonSaldo;
@property (nonatomic, retain) UIButton *botonContinuar;

//Control Cuentas
@property (nonatomic, retain) UITextField *textCuenta;
@property (nonatomic, retain) UIButton *botonCuenta;
@property (nonatomic, retain) UIButton *borrarCuenta;
@property (nonatomic, retain) UIPickerView* cuentas;
@property (nonatomic, retain) UIToolbar *ut;

@property (nonatomic, retain) UIView* barTeclado;

@property (nonatomic, retain) UILabel *limporte;
@property (nonatomic, retain) UILabel *lpeso;
@property (nonatomic, retain) UILabel *lcuenta;
@property (nonatomic, retain) UILabel *lTipoDoc;

@property (nonatomic, retain) UIView *containerTercero;
@property (nonatomic, retain) Cuenta *selectedCuenta;

@property (nonatomic, retain) UITextField *dniTxt;

@property BOOL extraTerceros;
@property (nonatomic, retain) NSMutableArray *listaCuentas;
@property (nonatomic, retain) UIActionSheet *subMenuDNI;
@property (nonatomic, retain) UIButton *barTecladoButton;

- (IBAction)selectCuenta:(id)sender;

@end
