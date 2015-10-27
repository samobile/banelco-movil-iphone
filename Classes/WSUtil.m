//
//  WSUtil.m
//  BanelcoMovil
//
//  Created by German Levy on 8/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WSUtil.h"
#import "GDataXMLNode.h"
#import "WSRequest.h"
#import "WebServicesHandler.h"
#import "CommonFunctions.h"
#import "Context.h"
#import "BanelcoMovilIphoneViewController.h"
#import "CommonUIFunctions.h"
#import "MenuBanelcoController.h"
#import "Util.h"
#import "CommonFuncBanelco.h"


@implementation WSUtil


+ (void)addProperty:(NSString *)namespace inSOAP:(GDataXMLElement *)soapObject withName:(NSString *)name andValue:(NSString *)value {

	GDataXMLElement *property = [GDataXMLNode elementWithName:name stringValue:value];
	[property addAttribute:[GDataXMLNode attributeWithName:@"xmlns" stringValue:namespace]];
	
	[soapObject addChild:property];

}

+ (id)execute:(WSRequest *)request {

	Context *context = [Context sharedContext];
	if (![self checkSession]) {
	//if (!context.allowRequest) {
		
		NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        [dict setValue:@"ss" forKey:@"faultCode"];
        [dict setValue:@"Sesión" forKey:@"faultstring"];
        [dict setValue:@"La sesión ha expirado" forKey:@"description"];
        [dict setValue:@"" forKey:@"exception"];
        [dict setValue:@"" forKey:@"tipoError"];
        
		[WSUtil performSelectorOnMainThread:@selector(showSessionAlert) withObject:nil waitUntilDone:YES];
        
        //[WSUtilP2P performSelectorOnMainThread:@selector(backSession) withObject:nil waitUntilDone:YES];
        
        [CommonUIFunctions goToLogin];
        
        return [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:dict];

		//[NSThread exit];
	}
	context.allowRequest = NO;

	WebServicesHandler *webservices = [[WebServicesHandler alloc] init];
    NSData *xmlDataReturned = [webservices callWebServiceGenericMOP:request];

    if (!xmlDataReturned || [xmlDataReturned length] == 0) {
        return nil;
    }
    
	id result = [self parseError:xmlDataReturned];
    if (!result) {
        result = [self parseNoSoapError:xmlDataReturned];
    }
	
	if (!result) {
		// Parseo el xml para obtener los datos devueltos
		result = [request parseResponse:xmlDataReturned];
        //result = [request parseResponse:nil];
		
	}

	return result;
	
}

/*- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	[CommonUIFunctions goToLogin];
	
}*/

+ (void)showSessionAlert {

	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	[CommonUIFunctions showAlert:@"Sesión" 
					 withMessage:@"La sesión ha expirado" 
				 andCancelButton:@"Ingresar Nuevamente"];
	
}

/**
 * <li>Controla que la sesion no haya expirado.
 * <li>Controla que el tiempo total de uso de la aplicacion no sea mayor 
 * que el tiempo total de sesion permitido.
 * <li>Controla que el tiempo de inactividad no sea mayor que el tiempo 
 * de inactividad permitido.
 * 
 * Si la sesion no expiro se setea la hora actual como la hora
 * de ultima actividad.  
 *  
 */
+ (BOOL) checkSession {
	
	Context *context = [Context sharedContext];
	double currentHour = [[NSDate date] timeIntervalSince1970];
	
	double startAppDiff = (currentHour - context.startAppHour);
	double lastActivityDiff = (currentHour - context.lastActivityHour);
	
	if ( (context.usuario) &&  
		((startAppDiff >= context.maxSessionTime)
		 || (lastActivityDiff >= context.maxInactivityTime))) {
			
		context.usuario = nil;
		
		return NO;
		
	} else {			
		
		context.lastActivityHour = currentHour;
		return YES;
		
	}
	
}


+ (id) parseError:(NSData *)data {
	
	NSError *error = [[NSError alloc]init];
	NSString *msj = [CommonFunctions returnFaultXMLTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
	
	if (!msj) {
		[error release];
		// Busco errores fuera del estandar SOAP
        return nil;//[self parseNoSoapError:data];
	}
	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error];
	GDataXMLElement *faultSoap = doc.rootElement;
	
	GDataXMLElement *detailSoap = [[faultSoap elementsForName:@"detail"] objectAtIndex:0];
	GDataXMLElement *REESoap = [[detailSoap elementsForName:@"RespuestaErroneaException"] objectAtIndex:0];
	GDataXMLElement *erroresSoap = [[REESoap elementsForName:@"errores"] objectAtIndex:0];
	GDataXMLElement *errorSoap = [[erroresSoap elementsForName:@"ns1:FaultCode"] objectAtIndex:0];
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:[WSUtil getStringProperty:@"faultcode" ofSoap:faultSoap] forKey:@"faultcode"];
	[dict setValue:[WSUtil getStringProperty:@"faultstring" ofSoap:faultSoap] forKey:@"faultstring"];
	
	if (errorSoap) {
		// Se agrega conversion de caracteres escapados (*a -> á).
		NSString *desc = [Util decodeISO8859:(NSString *)[WSUtil getStringProperty:@"description" ofSoap:errorSoap]]; 
		
		[dict setValue:desc forKey:@"description"];
		[dict setValue:[WSUtil getStringProperty:@"exception" ofSoap:errorSoap] forKey:@"exception"];
		[dict setValue:[WSUtil getStringProperty:@"tipoError" ofSoap:errorSoap] forKey:@"tipoError"];
	} else {
		NSString *msj = @"Esta transacción se encuentra momentáneamente inhabilitada. \n"
						 "Por favor, vuelva a intentarlo más tarde.";
		[dict setValue:msj forKey:@"description"];
		[dict setValue:@"" forKey:@"exception"];
		[dict setValue:@"" forKey:@"tipoError"];
	}

	
	[error release];
	
	return [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:dict];
	
}

+ (id) parseNoSoapError:(NSData *)data {
	
	NSString *msj = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	if ([msj rangeOfString:@"<soap:Body>"].location != NSNotFound) {
		return nil;
	}
	
	NSError *error = [[NSError alloc] init];
	//NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setValue:@"" forKey:@"faultcode"];
	[dict setValue:@"Error de servidor" forKey:@"faultstring"];
	[dict setValue:@"En este momento no se puede realizar la operación. Reintenta más tarde." forKey:@"description"];
    //[dict setValue:[NSString stringWithFormat:@"En este momento no se puede establecer conexión, por favor intente más tarde.\n\n%@",msj] forKey:@"description"];
	[dict setValue:@"" forKey:@"exception"];
	[dict setValue:@"server" forKey:@"tipoError"];
	
	[error release];
	
	return [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:dict];
	
}

+ (NSString *)getStringProperty:(NSString *)property ofSoap:(GDataXMLElement *)soap {

	return [(GDataXMLElement *)[[soap elementsForName:property] objectAtIndex:0] stringValue];

}

+ (int)getIntegerProperty:(NSString *)property ofSoap:(GDataXMLElement *)soap {
	
	return [[(GDataXMLElement *)[[soap elementsForName:property] objectAtIndex:0] stringValue] intValue];
	
}

+ (double)getDoubleProperty:(NSString *)property ofSoap:(GDataXMLElement *)soap {
	
	return [[(GDataXMLElement *)[[soap elementsForName:property] objectAtIndex:0] stringValue] doubleValue];
	
}

+ (NSDecimalNumber *)getDecimalProperty:(NSString *)property ofSoap:(GDataXMLElement *)soap {

	return [NSDecimalNumber decimalNumberWithString:[(GDataXMLElement *)[[soap elementsForName:property] objectAtIndex:0] stringValue]];
	
}

+ (BOOL)getBooleanProperty:(NSString *)property ofSoap:(GDataXMLElement *)soap {

	return [[(GDataXMLElement *)[[soap elementsForName:property] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	
}

+ (GDataXMLElement *)getRootElement:(NSString *)elementName inData:(NSData *)data {
	
	NSError *error = [[NSError alloc]init];
	
	NSString *msj = [CommonFunctions returnXMLMasterTagFromText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] withTag:elementName];
	//NSLog([NSString stringWithFormat:@"Lista Empresas Response: %@", msj]);	
	NSData *rdata = [NSData dataWithBytes:[msj UTF8String] length:[msj lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	
	return [[[GDataXMLDocument alloc] initWithData:rdata options:0 error:&error] rootElement];
	
}

+ (NSMutableArray *)parseStringList:(GDataXMLElement *)soap {
	return [soap elementsForName:@"string"];
}

+(NSString * )formatDateFromWS:(NSString *) fecha
{
    if(fecha == nil )
        return @"**/**/****";
    
    if(fecha.length < 5)//El 5 es un numero arbitrario que elegí, jamas una fecha puede tener menos de 5 digitos
    {
        return @"**/**/****";
    }
    
    if ([fecha rangeOfString:@"/"].location != NSNotFound) {
        return fecha;
    }
    
    fecha = [fecha substringToIndex:10];
    
//    NSDate *d = [CommonFuncBanelco NSStringToNSDate:fecha withFormat:[CommonFuncBanelco WSFormat]];
//    return [CommonFuncBanelco dateToNSString:d withFormat:[CommonFuncBanelco WSFormatProfileDOBInSpanish]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *yourDate = [dateFormatter dateFromString:fecha];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    return[dateFormatter stringFromDate:yourDate];
}

@end
