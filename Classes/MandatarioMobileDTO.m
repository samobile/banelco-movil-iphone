//
//  MandatarioMobileDTO.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/13/15.
//
//

#import "MandatarioMobileDTO.h"

@implementation MandatarioMobileDTO

@synthesize tipoDocMandatario, nroDocMandatario, tipoCuentaMandatario, nroCuentaMandatario;

- (NSString*)toSoapObject {
    
    return  [NSString stringWithFormat:
             @"<dto:nroCuentaMandatario>%@</dto:nroCuentaMandatario>"
             @"<dto:nroDocMandatario>%@</dto:nroDocMandatario>"
             @"<dto:tipoCuentaMandatario>%@</dto:tipoCuentaMandatario>"
             @"<dto:tipoDocMandatario>%@</dto:tipoDocMandatario>",
             self.nroCuentaMandatario ? self.nroCuentaMandatario : @"",
             self.nroDocMandatario ? self.nroDocMandatario : @"",
             self.tipoCuentaMandatario ? self.tipoCuentaMandatario : @"",
             self.tipoDocMandatario ? self.tipoDocMandatario : @""
             ];
    
    
//    NSMutableString* soap = [NSMutableString stringWithFormat:@""];
//    NSString* nameSpace = @"\"http://dto.mobile.services.pmctas.banelco.com\"";
//    [soap appendFormat:@"<n0:nroCuentaMandatario i:type=\"n0:string\" xmlns:n0=%@>%@</n0:nroCuentaMandatario>\n",nameSpace,self.nroCuentaMandatario ? self.nroCuentaMandatario : @""];
//    [soap appendFormat:@"<n1:nroDocMandatario i:type=\"n1:string\" xmlns:n1=%@>%@</n1:nroDocMandatario>\n",nameSpace,self.nroDocMandatario ? self.nroDocMandatario : @""];
//    [soap appendFormat:@"<n2:tipoCuentaMandatario i:type=\"n2:string\" xmlns:n2=%@>%@</n2:tipoCuentaMandatario>\n",nameSpace,self.tipoCuentaMandatario ? self.tipoCuentaMandatario : @""];
//    [soap appendFormat:@"<n3:tipoDocMandatario i:type=\"n3:string\" xmlns:n3=%@>%@</n3:tipoDocMandatario>\n",nameSpace,self.tipoDocMandatario ? self.tipoDocMandatario : @""];
    
//    return soap;
    
}

- (void)dealloc {
    self.tipoDocMandatario = nil;
    self.nroDocMandatario = nil;
    self.tipoCuentaMandatario = nil;
    self.nroCuentaMandatario = nil;
    [super dealloc];
}

@end
