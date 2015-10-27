//
//  MandatoBeanMobile.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/14/15.
//
//

#import "MandatoBeanMobile.h"

@implementation MandatoBeanMobile

@synthesize tipoDocumentoBeneficiario, numeroDocumentoBeneficiario, montoMandato, montoExtraido, fechaAlta, fechaVencimiento,fechaModificacion, codigoIdentificacionMandato, claveOperacion, estado, mandatario;

- (void)dealloc {
    self.tipoDocumentoBeneficiario = nil;
    self.numeroDocumentoBeneficiario = nil;
    self.montoMandato = nil;
    self.montoExtraido = nil;
    self.fechaAlta = nil;
    self.fechaVencimiento = nil;
    self.fechaModificacion = nil;
    self.codigoIdentificacionMandato = nil;
    self.claveOperacion = nil;
    self.estado = nil;
    self.mandatario = nil;
    [super dealloc];
}

@end
