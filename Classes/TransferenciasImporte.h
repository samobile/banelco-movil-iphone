//
//  TransferenciasImporte.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"


@interface TransferenciasImporte : WheelAnimationController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	
	IBOutlet UIButton *botonContinuar;
	IBOutlet UITextField *importeText;
	IBOutlet UILabel *importeLabel;
	IBOutlet UITextField *origenLabel;
	IBOutlet UITextField *destinoLabel;
	IBOutlet UIButton *botonCtaOrigen;
	IBOutlet UIButton *botonCtaDestino;
    IBOutlet UITextField *tarjetaText;
	//IBOutlet UIView *monedaSelector;
	
	IBOutlet UIButton *borrarOrigen;
	IBOutlet UIButton *borrarDestino;
	IBOutlet UILabel *destinoTitulo;
	
	IBOutlet UILabel *monedaLabel;
	IBOutlet UIButton *botonPeso;
	IBOutlet UIButton *botonDolar;
	
	UIPickerView* cuentas;
	
	NSString *titulo;
	
	UIImageView* barTeclado;
	UIButton* barTecladoButton;
	
	IBOutlet UILabel *origenTitulo;
	
	
}
@property(nonatomic,retain) UIButton* barTecladoButton;
@property(nonatomic,retain) UIImageView* barTeclado;

extern int const CTAS_VINCULADAS;
extern int const CTAS_AGENDADAS;

@property (nonatomic,retain) IBOutlet UIButton *botonContinuar;
@property (nonatomic,retain) IBOutlet UIButton *botonPeso;
@property (nonatomic,retain) IBOutlet UIButton *botonDolar;
@property (nonatomic,retain) IBOutlet UITextField *importeText;
@property (nonatomic,retain) IBOutlet UILabel *importeLabel;
@property (nonatomic,retain) IBOutlet UILabel *monedaLabel;
@property (nonatomic,retain) IBOutlet UITextField *origenLabel;
@property (nonatomic,retain) IBOutlet UITextField *destinoLabel;
@property (nonatomic,retain) IBOutlet UIButton *botonCtaOrigen;
@property (nonatomic,retain) IBOutlet UIButton *botonCtaDestino;
@property (nonatomic,retain) IBOutlet UILabel *destinoTitulo;
@property (nonatomic,retain) IBOutlet UITextField *tarjetaText;

@property (nonatomic,retain) IBOutlet UIButton *borrarOrigen;
@property (nonatomic,retain) IBOutlet UIButton *borrarDestino;

@property (nonatomic,retain) IBOutlet UIPickerView* cuentas;

@property (nonatomic, retain) NSString *titulo;

@property (nonatomic, retain) IBOutlet UILabel *origenTitulo;

- (id) initWithTitle:(NSString *)t ctasOrigen:(NSMutableArray *)o ctasDestino:(NSMutableArray *)d;
- (IBAction)selectCuenta:(id)sender;
- (IBAction)continuar;
- (IBAction)monedaButtonClicked:(id)sender;
- (IBAction)borrar:(id)sender;

@end
