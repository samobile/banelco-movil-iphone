//
//  SaldosTransfMobileDTO.h
//  BanelcoMovil
//
//  Created by German Levy on 8/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@class Cuenta;
@class GDataXMLElement;

@interface SaldosTransfMobileDTO : NSObject {

	NSString * saldo;

	NSString * disponible;
	
}

@property (nonatomic, retain) NSString * saldo;

@property (nonatomic, retain) NSString * disponible;

+ (SaldosTransfMobileDTO *) parseSaldosTransfMobileDTO:(GDataXMLElement *)dataSoap;
- (NSString *) getDescripcionSaldoTransf:(Cuenta *)cuenta;

@end
