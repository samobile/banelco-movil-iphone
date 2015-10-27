#import <Foundation/Foundation.h>
#import "Usuario.h"


@interface LoginResponse : NSObject {

	Usuario *usuario;
	
	NSMutableArray *cuentas;
	
	NSString *tokenSeguridad;
	
}

@property (nonatomic, retain) Usuario *usuario;

@property (nonatomic, retain) NSMutableArray *cuentas;

@property (nonatomic, retain) NSString *tokenSeguridad;


@end
