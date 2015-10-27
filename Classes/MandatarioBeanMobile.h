//
//  MandatarioBeanMobile.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/14/15.
//
//

#import <Foundation/Foundation.h>

@interface MandatarioBeanMobile : NSObject {
    NSString *tipoDocMandatario;
    NSString *nroDocMandatario;
    NSString *tipoCuentaMandatario;
    NSString *nroCuentaMandatario;
}

@property (nonatomic, retain) NSString *tipoDocMandatario;
@property (nonatomic, retain) NSString *nroDocMandatario;
@property (nonatomic, retain) NSString *tipoCuentaMandatario;
@property (nonatomic, retain) NSString *nroCuentaMandatario;

@end
