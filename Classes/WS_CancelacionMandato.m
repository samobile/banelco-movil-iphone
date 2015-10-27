//
//  CancelacionMandato.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/19/15.
//
//

#import "WS_CancelacionMandato.h"
#import "GDataXMLNode.h"
#import "WSUtil.h"
#import "CommonFunctions.h"
#import "MandatarioMobileDTO.h"
#import "MandatoMobileDTO.h"
#import "DatosAutenticacionMobileDTO.h"
#import "TerminalMobileDTO.h"
#import "AltaMandatoMobileDTO.h"

@implementation WS_CancelacionMandato

@synthesize userToken, codBanco, mandatario, mandato, autenticacion, terminal;

-(NSString *)getWSName {
    return @"cancelacionMandato";
}

-(NSString *)getSoapMessage {
    
    return  [NSString stringWithFormat:
             @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:mob=\"http://mobile.services.pmctas.banelco.com\" xmlns:dto=\"http://dto.mobile.services.pmctas.banelco.com\"><soapenv:Header/><soapenv:Body><mob:cancelacionMandato>"
             "<mob:in0>%@</mob:in0>"
             "<mob:in1>%@</mob:in1>"
             "<mob:in2>%@</mob:in2>"
             "<mob:in3>%@</mob:in3>"
             "<mob:in4>%@</mob:in4>"
             "<mob:in5>%@</mob:in5>"
             "</mob:cancelacionMandato></soapenv:Body></soapenv:Envelope>",
             self.userToken, [WSRequest securityToken], self.codBanco, [mandatario toSoapObject], [mandato toSoapObject], [terminal toSoapObject]
             ];
}


-(id)parseResponse:(NSData *)data {
    
    //return [NSNumber numberWithBool:YES];
    
    NSError *error = nil;
    
    NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
    
    NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
    GDataXMLElement *movSoap = doc.rootElement;
    if (!movSoap) {
        return nil;
    }
    //La respuesta de realizarPago es un Ticket
    NSNumber *response = [NSNumber numberWithBool:YES];
    
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
