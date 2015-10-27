//
//  WS_ConsultarMandatos.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/16/15.
//
//

#import "WS_ConsultarMandatos.h"
#import "GDataXMLNode.h"
#import "WSUtil.h"
#import "CommonFunctions.h"
#import "MandatarioMobileDTO.h"
#import "TerminalMobileDTO.h"
#import "MandatoBeanMobile.h"
#import "MandatarioBeanMobile.h"

@implementation WS_ConsultarMandatos

@synthesize userToken, codBanco, mandatario, terminal;

-(NSString *)getWSName {
    return @"consultarMandatos";
}

-(NSString *)getSoapMessage {
    
    return  [NSString stringWithFormat:
             @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:mob=\"http://mobile.services.pmctas.banelco.com\" xmlns:dto=\"http://dto.mobile.services.pmctas.banelco.com\"><soapenv:Header/><soapenv:Body><mob:consultarMandatos>"
             "<mob:in0>%@</mob:in0>"
             "<mob:in1>%@</mob:in1>"
             "<mob:in2>%@</mob:in2>"
             "<mob:in3>%@</mob:in3>"
             "<mob:in4>%@</mob:in4>"
             "</mob:consultarMandatos></soapenv:Body></soapenv:Envelope>",
             self.userToken, [WSRequest securityToken], self.codBanco, [mandatario toSoapObject], [terminal toSoapObject]
             ];
}

-(id)parseResponse:(NSData *)data {
    
//    NSMutableArray *resp = [[NSMutableArray alloc] init];
//    for (int i = 0; i i <; ) {
//
//    }
    
    //    AltaMandatoMobileDTO *response = [[[AltaMandatoMobileDTO alloc] init] autorelease];
    //    response.codigoIdentificacionMandato = @"299308";
    //    response.clave = @"222";
    //    response.fechaVencimiento = @"20/12/2015";
    //    return response;
    
    NSMutableArray *resp = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    
    NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
    
    NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
    GDataXMLElement *movSoap = doc.rootElement;
    if (!movSoap) {
        [doc release];
        return nil;
    }
    NSArray *lista = [movSoap elementsForName:@"listaMandatos"];
    if ([lista count] > 0) {
        lista = [(GDataXMLElement *)[lista objectAtIndex:0] elementsForName:@"MandatoBeanMobile"];
    }
    for (GDataXMLElement *elem in lista) {
        MandatoBeanMobile *mandato = [[MandatoBeanMobile alloc] init];
        mandato.tipoDocumentoBeneficiario = [[[elem elementsForName:@"tipoDocumentoBeneficiario"] objectAtIndex:0] stringValue];
        mandato.numeroDocumentoBeneficiario = [[[elem elementsForName:@"numeroDocumentoBeneficiario"] objectAtIndex:0] stringValue];
        mandato.montoMandato = [[[elem elementsForName:@"montoMandato"] objectAtIndex:0] stringValue];
        mandato.montoExtraido = [[[elem elementsForName:@"montoExtraido"] objectAtIndex:0] stringValue];
        NSString *st = [[[elem elementsForName:@"fechaAlta"] objectAtIndex:0] stringValue];
        st = [st substringToIndex:[st rangeOfString:@"T"].location];
        NSArray *f = [st componentsSeparatedByString:@"-"];
        if ([f count] >= 3) {
            mandato.fechaAlta = [NSString stringWithFormat:@"%@/%@/%@", [f objectAtIndex:2], [f objectAtIndex:1], [f objectAtIndex:0]];
        }
        st = [[[elem elementsForName:@"fechaVencimiento"] objectAtIndex:0] stringValue];
        st = [st substringToIndex:[st rangeOfString:@"T"].location];
        f = [st componentsSeparatedByString:@"-"];
        if ([f count] >= 3) {
            mandato.fechaVencimiento = [NSString stringWithFormat:@"%@/%@/%@", [f objectAtIndex:2], [f objectAtIndex:1], [f objectAtIndex:0]];
        }
        st = [[[elem elementsForName:@"fechaModificacion"] objectAtIndex:0] stringValue];
        st = [st substringToIndex:[st rangeOfString:@"T"].location];
        f = [st componentsSeparatedByString:@"-"];
        if ([f count] >= 3) {
            mandato.fechaModificacion = [NSString stringWithFormat:@"%@/%@/%@", [f objectAtIndex:2], [f objectAtIndex:1], [f objectAtIndex:0]];
        }
        mandato.codigoIdentificacionMandato = [[[elem elementsForName:@"codigoIdentificacionMandato"] objectAtIndex:0] stringValue];
        mandato.claveOperacion = [[[elem elementsForName:@"claveOperacion"] objectAtIndex:0] stringValue];
        mandato.estado = [[[elem elementsForName:@"estado"] objectAtIndex:0] stringValue];
        GDataXMLElement *elemMandatario = [[elem elementsForName:@"mandatario"] objectAtIndex:0];
        MandatarioBeanMobile *manda = [[MandatarioBeanMobile alloc] init];
        manda.tipoDocMandatario = [[[elemMandatario elementsForName:@"tipoDocMandatario"] objectAtIndex:0] stringValue];
        manda.nroDocMandatario = [[[elemMandatario elementsForName:@"nroDocMandatario"] objectAtIndex:0] stringValue];
        manda.tipoCuentaMandatario = [[[elemMandatario elementsForName:@"tipoCuentaMandatario"] objectAtIndex:0] stringValue];
        manda.nroCuentaMandatario = [[[elemMandatario elementsForName:@"nroCuentaMandatario"] objectAtIndex:0] stringValue];
        mandato.mandatario = manda;
        [manda release];
        [resp addObject:mandato];
        [mandato release];
    }
    
    [doc release];
    
    return [resp count] > 0 ? resp : nil;
    
}

- (void)dealloc {
    self.userToken = nil;
    self.codBanco = nil;
    self.mandatario = nil;
    self.terminal = nil;
    [super dealloc];
}

@end
