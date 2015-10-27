//
//  ExtraccionesDetalle.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/13/15.
//
//

#import "CustomDetail.h"

@class Cuenta, WaitingAlert;

@interface ExtraccionesDetalle : CustomDetail {
    
    IBOutlet UIButton *botonPagar;
    Cuenta *selectedCuenta;
    NSString *tipoDoc;
    NSString *importe;
    NSString *nroDoc;
    WaitingAlert *waiting;
}

@property (nonatomic, retain) UIButton *botonPagar;
@property (nonatomic, retain) Cuenta *selectedCuenta;
@property (nonatomic, retain) NSString *tipoDoc;
@property (nonatomic, retain) NSString *importe;
@property (nonatomic, retain) NSString *nroDoc;

@end
