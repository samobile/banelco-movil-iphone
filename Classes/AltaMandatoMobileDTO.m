//
//  AltaMandatoMobileDTO.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/14/15.
//
//

#import "AltaMandatoMobileDTO.h"

@implementation AltaMandatoMobileDTO

@synthesize codigoIdentificacionMandato, clave, fechaVencimiento;

- (void)dealloc {
    self.codigoIdentificacionMandato = nil;
    self.clave = nil;
    self.fechaVencimiento = nil;
    [super dealloc];
}

@end
