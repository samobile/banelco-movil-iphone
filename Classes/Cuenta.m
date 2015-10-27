#import "Cuenta.h"
#import "Util.h"
#import "Context.h"
#import "WSUtil.h"
#import "Movimiento.h"
#import "WS_ConsultaResumenCuenta.h"
#import "ResumenCuentaResponse.h"
#import "WS_ConsultarLimitesyDisponibles.h"
#import "WS_ConsultarSaldos.h"
#import "CommonUIFunctions.h"
#import "WS_ListarAgendaCBU.h"
#import "WS_ListarCuentasPlazo.h"

@implementation Cuenta

@synthesize codigo, codigoMoneda, codigoTipoCuenta, ctaEspecial, descripcionCortaTipoCuenta, descripcionLargaTipoCuenta;
@synthesize disponible, limite, numero, saldo, simboloMoneda, accountType;
@synthesize nombre, cuit, propia, organizacion, titular, segmento, mascara;


int const C_ACCOUNT = 0;
int const C_CBU = 1;
int const C_PLAZO = 2;


static NSString *mascara = nil;

+(void) initialize {
	[super initialize];
    if (!mascara)
        mascara = [[NSString alloc] init];
}


-(NSString*) getDescripcion {
	
	NSString *descripcion;
	
	if(self.accountType == C_ACCOUNT){
		NSLog(@"Descripcion?");

		descripcion = [NSString stringWithFormat:@"%@  %@", descripcionCortaTipoCuenta , [Util aplicarMascara:self.numero yMascara:[Cuenta getMascara]] ];

	}else if(self.accountType== C_CBU){
		if ((nombre)&&([nombre length]>0)){
			descripcion = self.nombre;
		}else{
			descripcion = self.codigo;
		}
	}else if(self.accountType == C_PLAZO){
		descripcion =[NSString stringWithFormat:@"Cuenta Plazo %i %@",self.simboloMoneda, self.numero];
	}
	return descripcion;
	
}

-(NSString*)descripcionParaCBU{
	NSString *descripcion = [NSString stringWithFormat:@"%@" , [Util aplicarMascara:self.numero yMascara:[Cuenta getMascara]] ];

	return descripcion;
}
- (NSString*)getDescripcionSaldo:(BOOL)limitesYDisponibles {
	
	NSMutableString * desc = [[NSMutableString alloc] init];
	
	[desc appendString:descripcionLargaTipoCuenta];
	
	[desc appendString:@"   "];
	
	[desc appendString:[Util aplicarMascara:self.numero yMascara:[Cuenta getMascara]]];
	
	[desc appendFormat:@"\nSaldo\n%@ %@", self.simboloMoneda, self.saldo];
	

	if (limitesYDisponibles) {
		[desc appendFormat:@"\n\nDisponible para pagos  %@ %@", self.simboloMoneda, self.disponible];
	}
	
	if (limitesYDisponibles) {
		[desc appendString:@"\n\nS.E.U.O."];
	} else {
		[desc appendString:@"\n\nS.E.U.O."];
	}
	
	return desc;
}

- (NSString *)getDescripcionSaldoAlerta:(BOOL)limitesYDisponibles {
	
	NSMutableString * desc = [[NSMutableString alloc] init];
	
	//se agrega el nro de cuenta al mesaje
	[desc appendFormat:@"%@", [self getDescripcion]];
	
	[desc appendFormat:@"\n\nSaldo\n%@ %@", self.simboloMoneda,[Util formatSaldo:self.saldo]];
	
	if (limitesYDisponibles) {
		[desc appendFormat:@"\n\nDisponible para pagos  \n%@ %@", self.simboloMoneda, [Util formatSaldo:self.disponible]];
		[desc appendFormat:@"\n\nLímite de pagos  \n%@ %@", self.simboloMoneda, [Util formatSaldo:self.limite]];
	}
	
	if (limitesYDisponibles) {
		[desc appendString:@"\n\nS.E.U.O."];
	} else {
		[desc appendString:@"\n\nS.E.U.O."];
	}
	
	return desc;
}


-(NSString*) getDescripcionLinea1 {
	return descripcionLargaTipoCuenta ;
}
-(NSString*) getDescripcionLinea2 {
	return [Util aplicarMascara:self.numero yMascara:[Cuenta getMascara]];
}

+ (Cuenta *) getSaldo:(Cuenta*)cuenta withLyD:(BOOL)limitesYDisponibles {
	
	Cuenta *cuentaResultado = nil;
	
	if (limitesYDisponibles) {
		
		WS_ConsultarLimitesyDisponibles *request = [[WS_ConsultarLimitesyDisponibles alloc] init];
		
		Context *context = [Context sharedContext];
		
		request.userToken = [context getToken];
		request.codigoCuenta = cuenta.codigo;
		
		cuentaResultado = [WSUtil execute:request];
		
	} else {
		
		WS_ConsultarSaldos *request = [[WS_ConsultarSaldos alloc] init];
		
		Context *context = [Context sharedContext];
		
		request.userToken = [context getToken];
		request.numeroCuenta = cuenta.numero;
		request.codigoTipoCuenta = [cuenta.codigoTipoCuenta intValue];
		request.codigoMonedaCuenta = cuenta.codigoMoneda;
		
		cuentaResultado = [WSUtil execute:request];

	}
	
	if (![cuentaResultado isKindOfClass:[NSError class]]) {
		
		cuenta.codigo = cuentaResultado.codigo; // TODO revisar que esto funcione
		
		return cuentaResultado;
	
	} else {
        
        NSString *errorCode = [[(NSError *)cuentaResultado userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return nil;
        }
		
		NSString *errorDesc = [[(NSError *)cuentaResultado userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:@"Saldo" withMessage:errorDesc andCancelButton:@"Volver"];
		
		return cuentaResultado;
		
	}
	
}


+ (void) setMascara:(NSString *)masc {

	mascara = [masc copy];
	
}

+ (NSString *) getMascara {

	return mascara;

}


+ (NSMutableArray *)parseCuentas:(GDataXMLElement *)cuentasSoap {
	
	NSLog(@"parseo cuentas...");
	
	NSMutableArray *cuentas = [[NSMutableArray alloc] init];
	
	NSArray *cuentasSoaps = [cuentasSoap elementsForName:@"CuentaMobile"];
	
	for (GDataXMLElement *cuentaSoap in cuentasSoaps) {
		NSLog(@"cuenta creada!");
		[cuentas addObject:[Cuenta parseCuenta:cuentaSoap]];
	}
	
	return cuentas;
}


-(NSString*) toSoapObject{
	
	NSMutableString* soap = [[NSMutableString alloc] init];
		
	NSLog(@"log");
	
//	<in1 i:type=":">
//	<n1:codigo i:type="n1:string" xmlns:n1="http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com">
//	[Saldo=0.0,Tipo=[Codigo=1,DescripcionCorta=CA  $,DescripcionLarga=Caja de Ahorro $,],Moneda=[Codigo=32,Simbolo=$,],Cbu=null,Limite=0.0,Intereses=0.0,Disponible=0.0,Numero=5127525015067,]
//	</n1:codigo>
//	<n2:codigoMoneda i:type="n2:int" xmlns:n2="http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com">32</n2:codigoMoneda>
//	<n3:codigoTipoCuenta i:type="n3:string" xmlns:n3="http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com">1</n3:codigoTipoCuenta>
//	<n4:ctaEspecial i:type="n4:boolean" xmlns:n4="http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com">false</n4:ctaEspecial>
//	<n5:descripcionCortaTipoCuenta i:type="n5:string" xmlns:n5="http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com">CA  $</n5:descripcionCortaTipoCuenta>
//	<n6:descripcionLargaTipoCuenta i:type="n6:string" xmlns:n6="http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com">Caja de Ahorro $</n6:descripcionLargaTipoCuenta>
//	<n7:disponible i:type="n7:double" xmlns:n7="http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com">0.0</n7:disponible>
//	<n8:limite i:type="n8:string" xmlns:n8="http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com">0.0</n8:limite>
//	<n9:numero i:type="n9:string" xmlns:n9="http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com">5127525015067</n9:numero>
//	<n10:saldo i:type="n10:string" xmlns:n10="http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com">0.0</n10:saldo>
//	<n11:simboloMoneda i:type="n11:string" xmlns:n11="http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com">$</n11:simboloMoneda>
//	</in1>
	
	
	if (accountType == C_ACCOUNT) {
		NSString* nameSpace = @"=\"http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com\"";
		//[soap appendFormat:@"<in1 i:type=\":\">"];
		[soap appendFormat:@"<n1:codigo i:type=\"n1:string\" xmlns:n1%@ >%@</n1:codigo>\n",nameSpace,codigo];
		[soap appendFormat:@"<n2:codigoMoneda i:type=\"n2:int\" xmlns:n2%@ >%d</n2:codigoMoneda>\n",nameSpace,codigoMoneda];
		[soap appendFormat:@"<n3:codigoTipoCuenta i:type=\"n3:string\" xmlns:n3%@ >%@</n3:codigoTipoCuenta>\n",nameSpace,codigoTipoCuenta];
		if(ctaEspecial){
			[soap appendFormat:@"<n4:ctaEspecial i:type=\"n4:boolean\" xmlns:n4%@ >%@</n4:ctaEspecial>\n",nameSpace,@"true"];
		}else {
			[soap appendFormat:@"<n4:ctaEspecial i:type=\"n4:boolean\" xmlns:n4%@ >%@</n4:ctaEspecial>\n",nameSpace,@"false"];
		}
		[soap appendFormat:@"<n5:descripcionCortaTipoCuenta i:type=\"n5:string\" xmlns:n5%@ >%@</n5:descripcionCortaTipoCuenta>\n",nameSpace,descripcionCortaTipoCuenta];
		[soap appendFormat:@"<n6:descripcionLargaTipoCuenta i:type=\"n6:string\" xmlns:n6%@ >%@</n6:descripcionLargaTipoCuenta>\n",nameSpace,descripcionLargaTipoCuenta];
		[soap appendFormat:@"<n7:disponible i:type=\"n7:double\" xmlns:n7%@ >%d</n7:disponible>\n",nameSpace,disponible];
		[soap appendFormat:@"<n8:limite i:type=\"n8:string\" xmlns:n8%@ >%@</n8:limite>\n",nameSpace,limite];
		[soap appendFormat:@"<n9:numero i:type=\"n9:string\" xmlns:n9%@ >%@</n9:numero>\n",nameSpace,numero];
		[soap appendFormat:@"<n10:saldo i:type=\"n10:string\" xmlns:n10%@ >%@</n10:saldo>\n",nameSpace,@"0.0"];
		[soap appendFormat:@"<n11:simboloMoneda i:type=\"n11:string\" xmlns:n11%@ >%@</n11:simboloMoneda>\n",nameSpace,simboloMoneda];
		//[soap appendFormat:@"</in1>"];
	} else {
		NSString* nameSpace =@"=\"http://transferencias.mobile.services.pmctas.banelco.com\"";
		[soap appendFormat:@"<n1:codigo i:type=\"n1:string\" xmlns:n1%@>%@</n1:codigo>\n",nameSpace,codigo];
		[soap appendFormat:@"<n2:cuit i:type=\"n2:string\" xmlns:n2%@>%@</n2:cuit>\n",nameSpace,cuit];
		[soap appendFormat:@"<n3:nombre i:type=\"n3:string\" xmlns:n3%@>%@</n3:nombre>\n",nameSpace,nombre];
		[soap appendFormat:@"<n4:propia i:type=\"n4:string\" xmlns:n4%@>%@</n4:propia>\n",nameSpace,propia];
	}
	return soap;
	
	
	
	
}

+ (Cuenta *)parseCuenta:(GDataXMLElement *)cuentaSoap {
	
	Cuenta *c = [[Cuenta alloc] init];
	
	c.codigo = [[[cuentaSoap elementsForName:@"codigo"] objectAtIndex:0] stringValue];
	c.codigoMoneda = [[[[cuentaSoap elementsForName:@"codigoMoneda"] objectAtIndex:0] stringValue] intValue];
	c.codigoTipoCuenta = [[[cuentaSoap elementsForName:@"codigoTipoCuenta"] objectAtIndex:0] stringValue];
	c.ctaEspecial = [[[[cuentaSoap elementsForName:@"ctaEspecial"] objectAtIndex:0] stringValue] isEqualToString:@"true"]? TRUE : FALSE;
	c.descripcionCortaTipoCuenta = [[[cuentaSoap elementsForName:@"descripcionCortaTipoCuenta"] objectAtIndex:0] stringValue];
	c.descripcionLargaTipoCuenta = [[[cuentaSoap elementsForName:@"descripcionLargaTipoCuenta"] objectAtIndex:0] stringValue];
	c.disponible = [[[cuentaSoap elementsForName:@"disponible"] objectAtIndex:0] stringValue];
	c.limite = [[[cuentaSoap elementsForName:@"limite"] objectAtIndex:0] stringValue];
	c.numero = [[[cuentaSoap elementsForName:@"numero"] objectAtIndex:0] stringValue];
	c.saldo = [[[cuentaSoap elementsForName:@"saldo"] objectAtIndex:0] stringValue];
	c.simboloMoneda = [[[cuentaSoap elementsForName:@"simboloMoneda"] objectAtIndex:0] stringValue];
	
	return c;

}

+ (Cuenta *)getDebugCuenta {
    Cuenta *c = [[Cuenta alloc] init];
	
	c.codigo = @"24524";
	c.codigoMoneda = 1;
	c.codigoTipoCuenta = @"34";
	c.ctaEspecial = FALSE;
	c.descripcionCortaTipoCuenta = @"24234";
	c.descripcionLargaTipoCuenta = @"3424324";
	c.disponible = @"23423";
	c.limite = @"3453454";
	c.numero = @"2342352524";
	c.saldo = @"23424";
	c.simboloMoneda = @"$";
	
	return c;
}

+ (NSMutableArray *)parseCuentasCBU:(GDataXMLElement *)cuentasSoap {
	
	NSMutableArray *cuentasCBU = [[NSMutableArray alloc] init];
	
	NSArray *cuentasSoaps = [cuentasSoap elementsForName:@"RegistroAgendaCBUMobileDTO"];
	
	for (GDataXMLElement *cuentaSoap in cuentasSoaps) {
		[cuentasCBU addObject:[Cuenta parseCuentaCBU:cuentaSoap]];
	}
	
	return cuentasCBU;
}	

+ (Cuenta *)parseCuentaCBU:(GDataXMLElement *)cuentaSoap {
	
	Cuenta *c = [[Cuenta alloc] init];
	
	c.accountType = C_CBU;
	c.codigo = [[[cuentaSoap elementsForName:@"codigo"] objectAtIndex:0] stringValue];
	c.cuit = [[[cuentaSoap elementsForName:@"cuit"] objectAtIndex:0] stringValue];
	c.nombre = [[[cuentaSoap elementsForName:@"nombre"] objectAtIndex:0] stringValue];
	c.propia = [[[cuentaSoap elementsForName:@"propia"] objectAtIndex:0] stringValue];

	return c;
	
}

- (NSString *)getDescripcionCuentaPlazo {
	
	return [NSString stringWithFormat:@"Cta. Plazo %@ %@",self.simboloMoneda,[Util aplicarMascara:self.numero yMascara:[Cuenta getMascara]]];
}

+ (NSMutableArray *)parseCuentasPlazo:(GDataXMLElement *)cuentasSoap {
	
	NSMutableArray *cuentasPlazo = [[NSMutableArray alloc] init];
	
	NSArray *cuentasSoaps = [cuentasSoap elementsForName:@"CuentaPlazoMobile"];
	
	for (GDataXMLElement *cuentaSoap in cuentasSoaps) {
		[cuentasPlazo addObject:[Cuenta parseCuentaPlazo:cuentaSoap]];
	}
	
	return cuentasPlazo;
}	

+ (Cuenta *)parseCuentaPlazo:(GDataXMLElement *)cuentaSoap {
	
	Cuenta *c = [[Cuenta alloc] init];
	
	c.codigo = [[[cuentaSoap elementsForName:@"codigo"] objectAtIndex:0] stringValue];
	c.codigoMoneda = [[[[cuentaSoap elementsForName:@"codigoMoneda"] objectAtIndex:0] stringValue] intValue];
	c.organizacion = [[[cuentaSoap elementsForName:@"codigoOrganizacion"] objectAtIndex:0] stringValue];
	c.titular = [[[cuentaSoap elementsForName:@"nombreTitular"] objectAtIndex:0] stringValue];
	c.numero = [[[cuentaSoap elementsForName:@"numero"] objectAtIndex:0] stringValue];
	c.simboloMoneda = [[[cuentaSoap elementsForName:@"simboloMoneda"] objectAtIndex:0] stringValue];
	
	return c;
	
}


+ (NSMutableArray *) getUltimosMovimientos:(Cuenta *)cuenta {
	
	WS_ConsultaResumenCuenta * request = [[WS_ConsultaResumenCuenta alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.token = [context getToken];
	
	//paramsValues[1] = account.toSoapObject();
	
	ResumenCuentaResponse *movimientosResponse = [WSUtil execute:request];
	
	[Movimiento setFechaConsulta:movimientosResponse.fechaConsulta];
	[Movimiento setSaldo:movimientosResponse.saldo];
	
	return movimientosResponse.movimientos;
}

+ (NSMutableArray *)getCuentasCBU {
	
	//if ([Context getCuentasCBU]) {
	//	return [Context getCuentasCBU];
	//}
	
	WS_ListarAgendaCBU *request = [[WS_ListarAgendaCBU alloc] init];
	request.userToken = [[Context sharedContext] getToken];
	
	id response = [WSUtil execute:request];
	
	if ([response isKindOfClass:[NSError class]]) {
        NSString *errorCode = [[(NSError *)response userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return nil;
        }
        
		//NSString *errorDesc = [[(NSError *)response userInfo] valueForKey:@"description"];
		//[CommonUIFunctions showAlert:@"Cuentas con CBU Agendadas" withMessage:errorDesc andCancelButton:@"Cerrar"];
		return response;
	}
	
	[Context setCuentasCBU:(NSMutableArray *)response];
	return [Context getCuentasCBU];
	
}

+ (NSMutableArray *)getCuentasPlazo {
	
	
	WS_ListarCuentasPlazo *request = [[WS_ListarCuentasPlazo alloc] init];
	request.userToken = [[Context sharedContext] getToken];
	
	id response = [WSUtil execute:request];
	
	return response;
	
}


@end
