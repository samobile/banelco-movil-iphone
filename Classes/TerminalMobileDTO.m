//
//  TerminalMobileDTO.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/13/15.
//
//

#import "TerminalMobileDTO.h"

@implementation TerminalMobileDTO

@synthesize terminal, datosTerminal, canal, direccionIp;

- (NSString*)toSoapObject {
    
    return  [NSString stringWithFormat:
             @"<dto:canal>%@</dto:canal>"
             @"<dto:datosTerminal>%@</dto:datosTerminal>"
             @"<dto:direccionIp>%@</dto:direccionIp>"
             @"<dto:terminal>%@</dto:terminal>",
             self.canal ? self.canal : @"",
             self.datosTerminal ? self.datosTerminal : @"",
             self.direccionIp ? self.direccionIp : @"",
             self.terminal ? self.terminal : @""
             ];
    
//    NSMutableString* soap = [NSMutableString stringWithFormat:@""];
//    NSString* nameSpace = @"\"http://dto.mobile.services.pmctas.banelco.com\"";
//    [soap appendFormat:@"<n13:canal i:type=\"n13:string\" xmlns:n13=%@>%@</n13:canal>\n",nameSpace,self.canal ? self.canal : @""];
//    [soap appendFormat:@"<n14:datosTerminal i:type=\"n14:string\" xmlns:n14=%@>%@</n14:datosTerminal>\n",nameSpace,self.datosTerminal ? self.datosTerminal : @""];
//    [soap appendFormat:@"<n15:direccionIp i:type=\"n15:string\" xmlns:n15=%@>%@</n15:direccionIp>\n",nameSpace,self.direccionIp ? self.direccionIp : @""];
//    [soap appendFormat:@"<n16:terminal i:type=\"n16:string\" xmlns:n16=%@>%@</n16:terminal>\n",nameSpace,self.terminal ? self.terminal : @""];
//    
//    return soap;
    
}

- (void)dealloc {
    self.terminal = nil;
    self.datosTerminal = nil;
    self.canal = nil;
    self.direccionIp = nil;
    [super dealloc];
}

@end
