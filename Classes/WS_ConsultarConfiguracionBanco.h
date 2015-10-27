//
//  WS_ConsultarConfiguracionBanco.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/7/15.
//
//

#import "WSRequest.h"

@interface WS_ConsultarConfiguracionBanco : WSRequest {
    
    NSString *userToken;
    NSString *json;
}

@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *json;

@end
