//
//  MandatoBeanMobile.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/14/15.
//
//

#import <Foundation/Foundation.h>

@class MandatarioBeanMobile;

@interface MandatoBeanMobile : NSObject {
    NSString *tipoDocumentoBeneficiario;
    NSString *numeroDocumentoBeneficiario;
    NSString *montoMandato;
    NSString *montoExtraido;
    NSString *fechaAlta;
    NSString *fechaVencimiento;
    NSString *fechaModificacion;
    NSString *codigoIdentificacionMandato;
    NSString *claveOperacion;
    NSString *estado;
    MandatarioBeanMobile *mandatario;
}

@property (nonatomic, retain) NSString *tipoDocumentoBeneficiario;
@property (nonatomic, retain) NSString *numeroDocumentoBeneficiario;
@property (nonatomic, retain) NSString *montoMandato;
@property (nonatomic, retain) NSString *montoExtraido;
@property (nonatomic, retain) NSString *fechaAlta;
@property (nonatomic, retain) NSString *fechaVencimiento;
@property (nonatomic, retain) NSString *fechaModificacion;
@property (nonatomic, retain) NSString *codigoIdentificacionMandato;
@property (nonatomic, retain) NSString *claveOperacion;
@property (nonatomic, retain) NSString *estado;
@property (nonatomic, retain) MandatarioBeanMobile *mandatario;

@end
