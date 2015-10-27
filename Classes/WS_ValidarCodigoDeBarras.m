//
//  WS_ValidarCodigoDeBarras.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/15/15.
//
//

#import "WS_ValidarCodigoDeBarras.h"
#import "GDataXMLNode.h"
#import "WSUtil.h"
#import "Deuda.h"
#import "Empresa.h"
#import "DeudasCodBarra.h"

@implementation WS_ValidarCodigoDeBarras

@synthesize userToken, codigoBarra, longitud, codEmpresa;

-(NSString *)getWSName {
    return @"validarCodigoDeBarras";
}

-(NSString *)getSoapMessage {
    return  [NSString stringWithFormat:
             @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
             "<v:Header />\n"
             "<v:Body>\n"
             "<n0:validarCodigoDeBarras id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
             "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
             "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
             "<in2 i:type=\"d:string\">%@</in2>\n" // codigo barra
             "<in3 i:type=\"d:int\">%u</in3>\n" // longitud
             "<in4 i:type=\"d:string\">%@</in4>\n" // codigo empresa
             "</n0:validarCodigoDeBarras>\n"
             "</v:Body>\n"
             "</v:Envelope>\n", userToken, [WSRequest securityToken], codigoBarra, (unsigned int)longitud, codEmpresa ? codEmpresa : @""
             ];
}


-(id)parseResponse:(NSData *)data {
    
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    
    GDataXMLElement *rootSoap = [WSUtil getRootElement:@"out" inData:data];
    
    //entries
    NSArray *entrySoap = [rootSoap elementsForName:@"entry"];
    for (GDataXMLElement *esoap in entrySoap) {
        NSArray *keySoap = [esoap elementsForName:@"key"];
        Empresa *e = nil;
        if ([keySoap count] > 0) {
            GDataXMLElement *empSoap = [keySoap objectAtIndex:0];
            e = [Empresa parseForCodBarra:empSoap withCodBarra:self.codigoBarra];
        }
        Deuda *d = nil;
        if (e) {
            NSArray *valueSoap = [esoap elementsForName:@"value"];
            if ([valueSoap count] > 0) {
                GDataXMLElement *soap = [valueSoap objectAtIndex:0];
                d = [[Deuda alloc] init];
                d.agregadaManualmente = [WSUtil getBooleanProperty:@"agregadaManualmente" ofSoap:soap];
                d.codigoEmpresa = [WSUtil getStringProperty:@"codigoEmpresa" ofSoap:soap];
                d.codigoRubro = [WSUtil getStringProperty:@"codigoRubro" ofSoap:soap];
                d.descPantalla = [WSUtil getStringProperty:@"descPantalla" ofSoap:soap];
                NSString *str = [[WSUtil getStringProperty:@"descripcionUsuario" ofSoap:soap] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                d.descripcionUsuario = [str length] > 0 ? str : nil;
                d.error = [WSUtil getStringProperty:@"error" ofSoap:soap];
                d.idAdelanto = [WSUtil getStringProperty:@"idAdelanto" ofSoap:soap];
                d.idCliente = [WSUtil getStringProperty:@"idCliente" ofSoap:soap];
                d.importe = [WSUtil getStringProperty:@"importe" ofSoap:soap];
                d.importePermitido = [WSUtil getIntegerProperty:@"importePermitido" ofSoap:soap];
                d.monedaCodigo = [WSUtil getIntegerProperty:@"monedaCodigo" ofSoap:soap];
                d.monedaSimbolo = [WSUtil getStringProperty:@"monedaSimbolo" ofSoap:soap];
                d.nombreEmpresa = [WSUtil getStringProperty:@"nombreEmpresa" ofSoap:soap];
                d.nroFactura = [WSUtil getStringProperty:@"nroFactura" ofSoap:soap];
                d.otroImporte = [WSUtil getStringProperty:@"otroImporte" ofSoap:soap];
                d.tipoEmpresa = [WSUtil getStringProperty:@"tipoEmpresa" ofSoap:soap];
                d.tipoPago = [WSUtil getIntegerProperty:@"tipoPago" ofSoap:soap];
                d.tituloIdentificacion = [WSUtil getStringProperty:@"tituloIdentificacion" ofSoap:soap];
                d.vencimiento = [WSUtil getStringProperty:@"vencimiento" ofSoap:soap];
            }
        }
        if (e && e.codigo) {
            DeudasCodBarra *dcb = [[DeudasCodBarra alloc] init];
            dcb.empresa = e;
            dcb.deuda = d;
            [dict setObject:dcb forKey:e.codigo];
            [e release];
            [d release];
            [dcb release];
        }
    }
    
    return dict;
    
}

- (void)dealloc {
    self.userToken = nil;
    self.codigoBarra = nil;
    [super dealloc];
}

@end
