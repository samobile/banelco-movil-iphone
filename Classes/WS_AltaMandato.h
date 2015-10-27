//
//  WS_AltaMandato.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/13/15.
//
//

#import "WSRequest.h"

@class MandatarioMobileDTO, MandatoMobileDTO, DatosAutenticacionMobileDTO, TerminalMobileDTO;

@interface WS_AltaMandato : WSRequest {
    NSString *userToken;
    NSString *codBanco;
    MandatarioMobileDTO *mandatario;
    MandatoMobileDTO *mandato;
    DatosAutenticacionMobileDTO *autenticacion;
    TerminalMobileDTO *terminal;
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *codBanco;
@property (nonatomic, retain) MandatarioMobileDTO *mandatario;
@property (nonatomic, retain) MandatoMobileDTO *mandato;
@property (nonatomic, retain) DatosAutenticacionMobileDTO *autenticacion;
@property (nonatomic, retain) TerminalMobileDTO *terminal;

@end
