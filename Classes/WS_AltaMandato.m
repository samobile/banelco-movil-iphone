//
//  WS_AltaMandato.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/13/15.
//
//

#import "WS_AltaMandato.h"
#import "GDataXMLNode.h"
#import "WSUtil.h"
#import "CommonFunctions.h"
#import "MandatarioMobileDTO.h"
#import "MandatoMobileDTO.h"
#import "DatosAutenticacionMobileDTO.h"
#import "TerminalMobileDTO.h"
#import "AltaMandatoMobileDTO.h"

@implementation WS_AltaMandato

@synthesize userToken, codBanco, mandatario, mandato, autenticacion, terminal;

-(NSString *)getWSName {
    return @"altaMandato";
}

-(NSString *)getSoapMessage {
    
    return  [NSString stringWithFormat:
             @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:mob=\"http://mobile.services.pmctas.banelco.com\" xmlns:dto=\"http://dto.mobile.services.pmctas.banelco.com\"><soapenv:Header/><soapenv:Body><mob:altaMandato>"
             "<mob:in0>%@</mob:in0>"
             "<mob:in1>%@</mob:in1>"
             "<mob:in2>%@</mob:in2>"
             "<mob:in3>%@</mob:in3>"
             "<mob:in4>%@</mob:in4>"
             "<mob:in5>%@</mob:in5>"
             "<mob:in6>%@</mob:in6>"
             "</mob:altaMandato></soapenv:Body></soapenv:Envelope>",
             self.userToken, [WSRequest securityToken], self.codBanco, [mandatario toSoapObject], [mandato toSoapObject], [autenticacion toSoapObject], [terminal toSoapObject]
             ];
//    
//    return  [NSString stringWithFormat:
//             @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//             "<v:Header />\n"
//             "<v:Body>\n"
//             "<n0:altaMandato id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
//             "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
//             "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
//             "<in2 i:type=\"d:string\">%@</in2>\n" // codigo banco
//             "<in3 i:type=\":\">%@</in3>\n" // mandatario
//             "<in4 i:type=\":\">%@</in4>\n" // mandato
//             "<in5 i:type=\":\">%@</in5>\n" // autenticacion
//             "<in6 i:type=\":\">%@</in6>\n" // terminal
//             "</n0:altaMandato>\n"
//             "</v:Body>\n"
//             "</v:Envelope>\n", self.userToken, [WSRequest securityToken], self.codBanco, [mandatario toSoapObject], [mandato toSoapObject], [autenticacion toSoapObject], [terminal toSoapObject]
//             ];
}


-(id)parseResponse:(NSData *)data {
    
//    AltaMandatoMobileDTO *response = [[[AltaMandatoMobileDTO alloc] init] autorelease];
//    response.codigoIdentificacionMandato = @"299308";
//    response.clave = @"222";
//    response.fechaVencimiento = @"20/12/2015";
//    return response;
    
    NSError *error = nil;
    
    NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
    
    NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
    GDataXMLElement *movSoap = doc.rootElement;
    if (!movSoap) {
        return nil;
    }
    //La respuesta de realizarPago es un Ticket
    AltaMandatoMobileDTO *response = [[[AltaMandatoMobileDTO alloc] init] autorelease];
    response.codigoIdentificacionMandato = [[[movSoap elementsForName:@"codigoIdentificacionMandato"] objectAtIndex:0] stringValue];
    response.clave = [[[movSoap elementsForName:@"clave"] objectAtIndex:0] stringValue];
    NSString *st = [[[movSoap elementsForName:@"fechaVencimiento"] objectAtIndex:0] stringValue];
    st = [st substringToIndex:[st rangeOfString:@"T"].location];
    NSArray *f = [st componentsSeparatedByString:@"-"];
    if ([f count] >= 3) {
        response.fechaVencimiento = [NSString stringWithFormat:@"%@/%@/%@", [f objectAtIndex:2], [f objectAtIndex:1], [f objectAtIndex:0]];
    }
    return response;
    
}

- (void)dealloc {
    self.userToken = nil;
    self.codBanco = nil;
    self.mandatario = nil;
    self.mandato = nil;
    self.autenticacion = nil;
    self.terminal = nil;
    [super dealloc];
}

@end
