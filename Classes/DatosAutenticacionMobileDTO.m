//
//  DatosAutenticacionMobileDTO.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/13/15.
//
//

#import "DatosAutenticacionMobileDTO.h"

@implementation DatosAutenticacionMobileDTO

@synthesize factor, nroSecuenciaAutenticacion, fechaHoraAutenticacion;

- (NSString*)toSoapObject {
    
    return  [NSString stringWithFormat:
             @"<dto:factor>%@</dto:factor>"
             @"<dto:fechaHoraAutenticacion>%@</dto:fechaHoraAutenticacion>"
             @"<dto:nroSecuenciaAutenticacion>%@</dto:nroSecuenciaAutenticacion>",
             self.factor ? self.factor : @"",
             self.fechaHoraAutenticacion ? self.fechaHoraAutenticacion : @"",
             self.nroSecuenciaAutenticacion ? self.nroSecuenciaAutenticacion : @""
             ];
    
//    NSMutableString* soap = [NSMutableString stringWithFormat:@""];
//    NSString* nameSpace = @"\"http://dto.mobile.services.pmctas.banelco.com\"";
//    [soap appendFormat:@"<n10:factor i:type=\"n10:string\" xmlns:n10=%@>%@</n10:factor>\n",nameSpace,self.factor ? self.factor : @""];
//    [soap appendFormat:@"<n11:nroSecuenciaAutenticacion i:type=\"n11:string\" xmlns:n11=%@>%@</n11:nroSecuenciaAutenticacion>\n",nameSpace,self.nroSecuenciaAutenticacion ? self.nroSecuenciaAutenticacion : @""];
//    [soap appendFormat:@"<n12:fechaHoraAutenticacion i:type=\"n12:string\" xmlns:n12=%@>%@</n12:fechaHoraAutenticacion>\n",nameSpace,self.fechaHoraAutenticacion ? self.fechaHoraAutenticacion : @""];
//    
//    return soap;
    
}

- (void)dealloc {
    self.factor = nil;
    self.nroSecuenciaAutenticacion = nil;
    self.fechaHoraAutenticacion = nil;
    [super dealloc];
}

@end
