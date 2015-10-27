//
//  WS_ConsultarConfiguracionBanco.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/7/15.
//
//

#import "WS_ConsultarConfiguracionBanco.h"
#import "GDataXMLNode.h"
#import "WSUtil.h"
#import "CommonFunctions.h"

@implementation WS_ConsultarConfiguracionBanco

@synthesize userToken, json;

-(NSString *)getWSName {
    return @"consultarConfiguracionBanco";
}

-(NSString *)getSoapMessage {
    return  [NSString stringWithFormat:
             @"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
             "<v:Header />\n"
             "<v:Body>\n"
             "<n0:consultarConfiguracionBanco id=\"o0\" c:root=\"1\" xmlns:n0=\"http://mobile.services.pmctas.banelco.com/\">\n"
             "<in0 i:type=\"d:string\">%@</in0>\n" // User Token
             "<in1 i:type=\"d:string\">%@</in1>\n" // Security Token
             "<in2 i:type=\"d:string\">%@</in2>\n" // json
             "</n0:consultarConfiguracionBanco>\n"
             "</v:Body>\n"
             "</v:Envelope>\n", userToken, [WSRequest securityToken], json];
}

-(id)parseResponse:(NSData *)data {
    NSString *txt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *msj = [CommonFunctions returnXMLMasterTagFromText:txt withTag:@"out"];
    if (msj) {
        msj = [msj stringByReplacingOccurrencesOfString:@"<out>" withString:@""];
        msj = [msj stringByReplacingOccurrencesOfString:@"</out>" withString:@""];
    }
    else {
        return nil;
    }
    NSError *error = nil;
    NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:[msj dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    [txt release];
    return [jsonObj objectForKey:@"extraccion"];
    
}

- (void)dealloc {
    self.userToken = nil;
    self.json = nil;
    [super dealloc];
}

@end
