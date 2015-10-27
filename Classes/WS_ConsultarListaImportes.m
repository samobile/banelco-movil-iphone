//
//  ConsultarUltimoResumenTC.m
//  BanelcoMovil
//
//  Created by German Levy on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WS_ConsultarListaImportes.h"
#import "WSUtil.h"
#import "CreditCardResumen.h"
#import "CommonFunctions.h"

@implementation WS_ConsultarListaImportes

@synthesize userToken, rCel;

-(NSString *)getWSName {
	return @"consultarListaImportes";
}

// SERVICIOS 2.0
-(NSString *)getSoapMessage {
	return  [NSString stringWithFormat:
			 @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
			 "<v:Header />\n"
			 "<v:Body>\n"
			 "<n0:consultarListaImportes id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
			 "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
			 "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
			 "<in2 i:type=\"d:string\">%@</in2>\n" // codigo recarga
			 "</n0:consultarListaImportes>\n"
			 "</v:Body>\n"
			 "</v:Envelope>\n", userToken, [WSRequest securityToken], rCel
			 ];
}

-(id)parseResponse:(NSData *)data {

	//GDataXMLElement *rootSoap = [WSUtil getRootElement:@"ArrayOfRubroMobileDTO" inData:data];
	
	// TODO
	
	//return nil;
	
	NSError *error = nil;
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:@"out"];
	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *movSoap = doc.rootElement;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSArray *valuesElem = [movSoap elementsForName:@"string"];
    for (GDataXMLElement *elem in valuesElem) {
        [values addObject:[elem stringValue]];
    }
	
    return [values count] == 0 ? nil : values;
}

@end
