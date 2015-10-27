//
//  AltaMandatoMobileDTO.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/14/15.
//
//

#import <Foundation/Foundation.h>

@interface AltaMandatoMobileDTO : NSObject {
    NSString *codigoIdentificacionMandato;
    NSString *clave;
    NSString *fechaVencimiento;
}

@property (nonatomic, retain) NSString *codigoIdentificacionMandato;
@property (nonatomic, retain) NSString *clave;
@property (nonatomic, retain) NSString *fechaVencimiento;

@end
