//
//  MandatoMobileDTO.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/13/15.
//
//

#import "MandatoMobileDTO.h"

@implementation MandatoMobileDTO

@synthesize tipoDocBeneficiario, nroDocBeneficiario, codigoIdentificacionMandato, montoMandato, fechaVencimiento, isBaja;

- (NSString*)toSoapObject {
    
    return  [NSString stringWithFormat:
             @"<dto:baja>%@</dto:baja>"
             @"<dto:codigoIdentificacionMandato>%@</dto:codigoIdentificacionMandato>"
             @"<dto:fechaVencimiento>%@</dto:fechaVencimiento>"
             @"<dto:montoMandato>%@</dto:montoMandato>"
             @"<dto:nroDocBeneficiario>%@</dto:nroDocBeneficiario>"
             @"<dto:tipoDocBeneficiario>%@</dto:tipoDocBeneficiario>",
             self.isBaja ? @"true" : @"false",
             self.codigoIdentificacionMandato ? self.codigoIdentificacionMandato : @"",
             self.fechaVencimiento ? self.fechaVencimiento : @"",
             self.montoMandato ? self.montoMandato : @"",
             self.nroDocBeneficiario ? self.nroDocBeneficiario : @"",
             self.tipoDocBeneficiario ? self.tipoDocBeneficiario : @""
             ];
    
//    NSMutableString* soap = [NSMutableString stringWithFormat:@""];
//    NSString* nameSpace = @"\"http://dto.mobile.services.pmctas.banelco.com\"";
//    [soap appendFormat:@"<n4:baja i:type=\"n4:string\" xmlns:n4=%@>%@</n4:baja>\n",nameSpace,self.isBaja ? @"true" : @"false"];
//    [soap appendFormat:@"<n5:codigoIdentificacionMandato i:type=\"n5:string\" xmlns:n5=%@>%@</n5:codigoIdentificacionMandato>\n",nameSpace,self.codigoIdentificacionMandato ? self.codigoIdentificacionMandato : @""];
//    [soap appendFormat:@"<n6:fechaVencimiento i:type=\"n6:string\" xmlns:n6=%@>%@</n6:fechaVencimiento>\n",nameSpace,self.fechaVencimiento ? self.fechaVencimiento : @""];
//    [soap appendFormat:@"<n7:montoMandato i:type=\"n7:string\" xmlns:n7=%@>%@</n7:montoMandato>\n",nameSpace,self.montoMandato ? self.montoMandato : @""];
//    [soap appendFormat:@"<n8:nroDocBeneficiario i:type=\"n8:string\" xmlns:n8=%@>%@</n8:nroDocBeneficiario>\n",nameSpace,self.nroDocBeneficiario ? self.nroDocBeneficiario : @""];
//    [soap appendFormat:@"<n9:tipoDocBeneficiario i:type=\"n9:string\" xmlns:n9=%@>%@</n9:tipoDocBeneficiario>\n",nameSpace,self.tipoDocBeneficiario ? self.tipoDocBeneficiario : @""];
//    
//    return soap;
    
}

- (void)dealloc {
    self.tipoDocBeneficiario = nil;
    self.montoMandato = nil;
    self.nroDocBeneficiario = nil;
    self.codigoIdentificacionMandato = nil;
    self.fechaVencimiento = nil;
    [super dealloc];
}

@end
