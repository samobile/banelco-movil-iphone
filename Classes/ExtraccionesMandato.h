//
//  ExtraccionesMandato.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/14/15.
//
//

#import "StackableScreen.h"

@class MandatoBeanMobile, WaitingAlert, ExtraccionesConsultas;

@interface ExtraccionesMandato : StackableScreen <UIAlertViewDelegate> {
    IBOutlet UILabel* ordenTitle;
    IBOutlet UILabel* destTitle;
    IBOutlet UILabel* destLbl;
    IBOutlet UILabel* importeTitle;
    IBOutlet UILabel* importeLbl;
    IBOutlet UILabel* cuentaTitle;
    IBOutlet UILabel* cuentaLbl;
    IBOutlet UILabel* statusTitle;
    IBOutlet UILabel* statusLbl;
    IBOutlet UILabel* fechaLbl;
    
    MandatoBeanMobile *mandatoBean;
    IBOutlet UIImageView *fndTicket;
    IBOutlet UIButton *btnAnular;
    WaitingAlert *waiting;
    ExtraccionesConsultas *consultasDelegate;
}

@property (nonatomic, retain) UILabel* ordenTitle;
@property (nonatomic, retain) UILabel* destTitle;
@property (nonatomic, retain) UILabel* destLbl;
@property (nonatomic, retain) UILabel* importeTitle;
@property (nonatomic, retain) UILabel* importeLbl;
@property (nonatomic, retain) UILabel* cuentaTitle;
@property (nonatomic, retain) UILabel* cuentaLbl;
@property (nonatomic, retain) UILabel* statusTitle;
@property (nonatomic, retain) UILabel* statusLbl;
@property (nonatomic, retain) UILabel* fechaLbl;
@property (nonatomic, retain) MandatoBeanMobile *mandatoBean;
@property (nonatomic, retain) UIImageView *fndTicket;
@property (nonatomic, retain) UIButton *btnAnular;
@property (nonatomic, retain) WaitingAlert *waiting;
@property (nonatomic, assign) ExtraccionesConsultas *consultasDelegate;

- (id) initWithTitle:(NSString *)t;

@end
