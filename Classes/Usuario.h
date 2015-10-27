//
//  Usuario.h
//  BanelcoMovil_Prueba
//
//  Created by German Levy on 8/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Usuario : NSObject {

	BOOL firstLogin;
	NSString *fullname;
	BOOL needsPinChange;
	NSString *token;
	NSString *userName;
	BOOL viewTerminos;
	NSString *celular;
	NSString *operadorCelular;
	BOOL showVencim;
	BOOL showInfo;
	NSString *email;
	BOOL marcaVencim;
	BOOL marcaInfo;
	NSString *profile; //R:Restringido, F:Completo
    NSDate * vencimiento;
    NSDate * ultimoLogin;
	NSString *nroDocumento;
    NSString *tipoDocumento;
}

@property BOOL firstLogin;
@property (nonatomic,retain) NSString *fullname;
@property BOOL needsPinChange;
@property (nonatomic,retain) NSString *token;
@property (nonatomic,retain) NSString *userName;
@property BOOL viewTerminos;
@property (nonatomic,retain) NSString *celular;
@property (nonatomic,retain) NSString *operadorCelular;
@property BOOL showVencim;
@property BOOL showInfo;
@property (nonatomic,retain) NSString *email;
@property BOOL marcaVencim;
@property BOOL marcaInfo;
@property (nonatomic,retain) NSString *profile;
@property (nonatomic,retain) NSDate * vencimiento;
@property (nonatomic,retain)   NSDate * ultimoLogin;
@property (nonatomic,retain) NSString *nroDocumento;
@property (nonatomic,retain) NSString *tipoDocumento;

-(BOOL) esRestringido;

@end
