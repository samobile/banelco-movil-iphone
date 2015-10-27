//
//  DatosAutenticacionMobileDTO.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/13/15.
//
//

#import <Foundation/Foundation.h>

@interface DatosAutenticacionMobileDTO : NSObject {
    NSString *factor;
    NSString *nroSecuenciaAutenticacion;
    NSString *fechaHoraAutenticacion;
}

@property (nonatomic, retain) NSString *factor;
@property (nonatomic, retain) NSString *nroSecuenciaAutenticacion;
@property (nonatomic, retain) NSString *fechaHoraAutenticacion;

- (NSString*)toSoapObject;

@end
