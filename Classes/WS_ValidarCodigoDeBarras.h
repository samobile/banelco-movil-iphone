//
//  WS_ValidarCodigoDeBarras.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/15/15.
//
//

#import <Foundation/Foundation.h>
#import "WSRequest.h"

@interface WS_ValidarCodigoDeBarras : WSRequest {
    
    NSString *userToken;
    NSString *codigoBarra;
    NSUInteger longitud;
    NSString *codEmpresa;
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *codigoBarra;
@property NSUInteger longitud;
@property (nonatomic, retain) NSString *codEmpresa;

@end
