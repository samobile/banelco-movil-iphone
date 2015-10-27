//
//  WS_ConsultarMandatos.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/16/15.
//
//

#import "WSRequest.h"

@class MandatarioMobileDTO, TerminalMobileDTO;

@interface WS_ConsultarMandatos : WSRequest {
    NSString *userToken;
    NSString *codBanco;
    MandatarioMobileDTO *mandatario;
    TerminalMobileDTO *terminal;
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *codBanco;
@property (nonatomic, retain) MandatarioMobileDTO *mandatario;
@property (nonatomic, retain) TerminalMobileDTO *terminal;

@end
