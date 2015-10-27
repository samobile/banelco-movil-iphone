//
//  TerminalMobileDTO.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/13/15.
//
//

#import <Foundation/Foundation.h>

@interface TerminalMobileDTO : NSObject {
    NSString *terminal;
    NSString *datosTerminal;
    NSString *canal;
    NSString *direccionIp;
}

@property (nonatomic, retain) NSString *terminal;
@property (nonatomic, retain) NSString *datosTerminal;
@property (nonatomic, retain) NSString *canal;
@property (nonatomic, retain) NSString *direccionIp;

- (NSString*)toSoapObject;

@end
