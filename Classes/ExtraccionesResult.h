//
//  ExtraccionesResult.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/14/15.
//
//

#import "StackableScreen.h"

@class AltaMandatoMobileDTO, Cuenta, MandatarioMobileDTO, MandatoMobileDTO;

@interface ExtraccionesResult : StackableScreen {
    IBOutlet UILabel* ordenTitle;
    IBOutlet UILabel* destTitle;
    IBOutlet UILabel* destLbl;
    IBOutlet UILabel* importeTitle;
    IBOutlet UILabel* importeLbl;
    IBOutlet UILabel* cuentaTitle;
    IBOutlet UILabel* cuentaLbl;
    IBOutlet UILabel* codigoTitle;
    IBOutlet UILabel* codigoLbl;
    IBOutlet UILabel* leyendaTilte;
    IBOutlet UILabel* vigenteTitle;
    
    AltaMandatoMobileDTO *altaMandato;
    Cuenta *cuenta;
    MandatarioMobileDTO *mandatario;
    MandatoMobileDTO *mandato;
}

@property (nonatomic, retain) UILabel* ordenTitle;
@property (nonatomic, retain) UILabel* destTitle;
@property (nonatomic, retain) UILabel* destLbl;
@property (nonatomic, retain) UILabel* importeTitle;
@property (nonatomic, retain) UILabel* importeLbl;
@property (nonatomic, retain) UILabel* cuentaTitle;
@property (nonatomic, retain) UILabel* cuentaLbl;
@property (nonatomic, retain) UILabel* codigoTitle;
@property (nonatomic, retain) UILabel* codigoLbl;
@property (nonatomic, retain) UILabel* leyendaTilte;
@property (nonatomic, retain) UILabel* vigenteTitle;

@property (nonatomic, retain) AltaMandatoMobileDTO *altaMandato;
@property (nonatomic, retain) Cuenta *cuenta;
@property (nonatomic, retain) MandatarioMobileDTO *mandatario;
@property (nonatomic, retain) MandatoMobileDTO *mandato;

- (id) initWithTitle:(NSString *)t;

@end
