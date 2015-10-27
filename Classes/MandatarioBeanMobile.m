//
//  MandatarioBeanMobile.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/14/15.
//
//

#import "MandatarioBeanMobile.h"

@implementation MandatarioBeanMobile

@synthesize tipoDocMandatario, nroDocMandatario, tipoCuentaMandatario, nroCuentaMandatario;

- (void)dealloc {
    self.tipoDocMandatario = nil;
    self.nroDocMandatario = nil;
    self.tipoCuentaMandatario = nil;
    self.nroCuentaMandatario = nil;
    [super dealloc];
}

@end
