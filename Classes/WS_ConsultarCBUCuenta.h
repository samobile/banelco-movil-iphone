#import <Foundation/Foundation.h>
#import "WSRequest.h"

@interface WS_ConsultarCBUCuenta : WSRequest {

	
	/*
	 
	 paramsValues[0] = Context.getInstance().getToken();	
	 paramsValues[1] = account.numero;
	 paramsValues[2] = Integer.valueOf(account.codigoTipoCuenta);
	 paramsValues[3] = new Integer(account.codigoMoneda);	
	 
	 */
	NSString* userToken;
	NSString* numeroCuenta;
	int tipoCuenta;
	int codigoMoneda;
	
}


@property (nonatomic,retain) NSString* userToken; 
@property (nonatomic,retain) NSString* numeroCuenta;
@property  int tipoCuenta;
@property  int codigoMoneda;


@end
