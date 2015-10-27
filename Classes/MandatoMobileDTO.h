//
//  MandatoMobileDTO.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/13/15.
//
//

#import <Foundation/Foundation.h>

@interface MandatoMobileDTO : NSObject {
    NSString *tipoDocBeneficiario;
    NSString *nroDocBeneficiario;
    NSString *codigoIdentificacionMandato;
    NSString *montoMandato;
    NSString *fechaVencimiento;
    BOOL isBaja;
}

@property (nonatomic, retain) NSString *tipoDocBeneficiario;
@property (nonatomic, retain) NSString *nroDocBeneficiario;
@property (nonatomic, retain) NSString *codigoIdentificacionMandato;
@property (nonatomic, retain) NSString *montoMandato;
@property (nonatomic, retain) NSString *fechaVencimiento;
@property BOOL isBaja;

- (NSString*)toSoapObject;

@end
