//
//  SolicitudProducto.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import "WaitingAlert.h"

@class Producto;

@interface SolicitudProducto : WheelAnimationController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	
	IBOutlet UITextField *textProducto;
	IBOutlet UITextField *textTelContacto;
	IBOutlet UITextField *textTelAlter;
	IBOutlet UITextField *textEmail;
	IBOutlet UITextField *textDominio;
	
	IBOutlet UIButton *botonAceptar;
	IBOutlet UIButton *botonProducto;
	IBOutlet UIButton *borrarProducto;
	
	UIPickerView* productos;
	NSMutableArray *listaProductos;
	
	UIImageView* barTeclado;
	UIButton* barTecladoButton;
	
	UIToolbar *toolBarCta;
	
	IBOutlet UILabel *arroba;
	
	Producto *productoSelected;
	
	WaitingAlert *waiting;
	
	UIButton *blankButton;
	
}

@property (nonatomic, retain) UIButton *blankButton;
@property (nonatomic, retain) IBOutlet UITextField *textProducto;
@property (nonatomic, retain) IBOutlet UITextField *textTelContacto;
@property (nonatomic, retain) IBOutlet UITextField *textTelAlter;
@property (nonatomic, retain) IBOutlet UITextField *textEmail;
@property (nonatomic, retain) IBOutlet UITextField *textDominio;
@property (nonatomic, retain) IBOutlet UIButton *botonAceptar;
@property (nonatomic, retain) IBOutlet UIButton *botonProducto;
@property (nonatomic, retain) IBOutlet UIButton *borrarProducto;
@property (nonatomic, retain) UIPickerView* productos;
@property (nonatomic, retain) NSMutableArray *listaProductos;
@property (nonatomic, retain) UIImageView* barTeclado;
@property (nonatomic, retain) UIButton* barTecladoButton;
@property (nonatomic, retain) UIToolbar *toolBarCta;
@property (nonatomic, retain) IBOutlet UILabel *arroba;
@property (nonatomic, retain) Producto *productoSelected;
@property (nonatomic, retain) WaitingAlert *waiting;

- (id) initWithTitle:(NSString *)t;
- (IBAction) selectProducto:(id)sender;
- (void) ocultarProductos;
- (IBAction)borrar:(id)sender;
- (IBAction)aceptar:(id)sender;
- (IBAction)keyboardButtonAction;


@end