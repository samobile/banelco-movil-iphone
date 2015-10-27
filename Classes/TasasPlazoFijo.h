//
//  TasasPlazoFijo.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import "Cuenta.h"

@interface TasasPlazoFijo : WheelAnimationController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {

	IBOutlet UIButton *botonAceptar;
	
	IBOutlet UITextField *importeText;
	IBOutlet UILabel *importeLabel;


	IBOutlet UIButton *botonCtaPlazo;
	IBOutlet UIButton *borrarPlazo;
	IBOutlet UITextField *textCtaPlazo;
	
	UIPickerView* cuentas;
	NSMutableArray *listaCuentas;
	
	UIImageView* barTeclado;
	UIButton* barTecladoButton;
	
	Cuenta *ctaPlazoSelected;
	
	IBOutlet UITextField *textPlazo;
	
	UIToolbar *toolBarCta;
	
	UIButton *blankButton;
	
}

@property (nonatomic, retain) UIButton *blankButton;

@property (nonatomic, retain) IBOutlet UIButton *botonAceptar;
@property (nonatomic, retain) IBOutlet UITextField *importeText;
@property (nonatomic, retain) IBOutlet UILabel *importeLabel;

@property (nonatomic, retain) IBOutlet UIButton *botonCtaPlazo;
@property (nonatomic, retain) IBOutlet UIButton *borrarPlazo;
@property (nonatomic, retain) IBOutlet UITextField *textCtaPlazo;

@property (nonatomic, retain) NSMutableArray *listaCuentas;

@property (nonatomic, retain) Cuenta *ctaPlazoSelected;

@property (nonatomic, retain) UIPickerView* cuentas;
@property (nonatomic, retain) UIImageView* barTeclado;
@property (nonatomic, retain) UIButton* barTecladoButton;

@property (nonatomic, retain) IBOutlet UITextField *textPlazo;

@property (nonatomic, retain) UIToolbar *toolBarCta;

- (id) initWithTitle:(NSString *)t;
- (IBAction)selectCuenta:(id)sender;
- (IBAction)aceptar:(id)sender;
- (IBAction)borrar:(id)sender;


@end
