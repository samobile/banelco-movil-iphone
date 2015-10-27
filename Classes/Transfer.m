
#import "Transfer.h"
#import "WS_ConsultarSaldosyDisponTransf.h"
#import "WS_ConsultarUltimasTransf.h"
#import "WSUtil.h"

@implementation Transfer

@synthesize cuentaOrigen, concepto, cuentaDestino;

@synthesize type, importe, moneda;

@synthesize cotizacion, importeConvertido, referencia, cruzada, tInmediata,tarjeta;


+ (SaldosTransfMobileDTO *) getSaldoTransfer:(Cuenta *)account {
	
	WS_ConsultarSaldosyDisponTransf *request = [[WS_ConsultarSaldosyDisponTransf alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	request.nroCuenta = account.numero;
	request.tipoCuenta = [NSNumber numberWithInt:[account.codigoTipoCuenta intValue]];
	request.codMoneda = [NSNumber numberWithInt:account.codigoMoneda];
	
	return [WSUtil execute:request];
	
}

- (NSString *) createConfirmMessage {
	
	NSString *strConfirmacion;

	if (cruzada) {
		strConfirmacion = @"Ud. esta transfiriendo\n";
		strConfirmacion = [strConfirmacion stringByAppendingFormat: @"DE: %@\n", self.cuentaOrigen.descripcionCortaTipoCuenta];
		strConfirmacion = [strConfirmacion stringByAppendingFormat: @"%@ %@\n", cuentaOrigen.simboloMoneda, self.importe];
		strConfirmacion = [strConfirmacion stringByAppendingFormat: @"A: %@\n", cuentaDestino.descripcionCortaTipoCuenta];
		strConfirmacion = [strConfirmacion stringByAppendingFormat: @"%@ %@\n", cuentaDestino.simboloMoneda, self.importeConvertido];
		strConfirmacion = [strConfirmacion stringByAppendingFormat: @"%@\n", self.cotizacion];
		strConfirmacion = [strConfirmacion stringByAppendingFormat: @"%@\n", self.cuentaOrigen.descripcionCortaTipoCuenta];
		strConfirmacion = [strConfirmacion stringByAppendingFormat: @"%@\n", self.cuentaOrigen.descripcionCortaTipoCuenta];
		strConfirmacion = [strConfirmacion stringByAppendingString:@"DECLARO NO INFRINGIR R.P.CAM.Y \nCOM.A3722/4349/4377 Y COMP.BCRA\n"];
		strConfirmacion = [strConfirmacion stringByAppendingString:@"OPER. SUJ. AL REG. PENAL CAMB. \nLEGIS. Y NORM. BCRA APLICABLES"];
	}
	else
    {
		strConfirmacion = @"Ud. esta transfiriendo por \n";
		strConfirmacion = [strConfirmacion stringByAppendingFormat: @"%@ ", cuentaOrigen.simboloMoneda];
		strConfirmacion = [strConfirmacion stringByAppendingFormat: @"%@\n", importe];
		strConfirmacion = [strConfirmacion stringByAppendingFormat: @"DE: %@\n", self.cuentaOrigen.descripcionCortaTipoCuenta];
		strConfirmacion = [strConfirmacion stringByAppendingFormat: @"A: %@\n", cuentaDestino.descripcionCortaTipoCuenta];
		strConfirmacion = [strConfirmacion stringByAppendingString:@"PLAZO: minimo 48 hs.\n"];
		strConfirmacion = [strConfirmacion stringByAppendingString:@"Operacion sujeta a comisiones determinadas por su Banco + imp."];
	}

    return strConfirmacion;
	
  }

+ (NSMutableArray *) getUltimasTransferencias {
	
	WS_ConsultarUltimasTransf *request = [[WS_ConsultarUltimasTransf alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	
	return [WSUtil execute:request];
	
}

-(NSString*) toSoapObjectCBU {
	
	NSMutableString* soap = [[NSMutableString alloc] init];
	
	NSString* nameSpace = @"\"http://transferencias.mobile.services.pmctas.banelco.com\"";
	NSString* nameSpace2 = @"\"http://mobile.services.pmctas.banelco.com\"";
	NSString* nameSpace3 = @"=\"http://impl.cuentas.consultas.mobile.services.pmctas.banelco.com\"";
	
	[soap appendFormat:@"<n1:cbuDestino i:type=\"n1:string\" xmlns:n1=%@>%@</n1:cbuDestino>\n",nameSpace,cuentaDestino.codigo ];
	[soap appendFormat:@"<n2:cbuInAgenda i:type=\"n2:boolean\" xmlns:n2=%@>%@</n2:cbuInAgenda>\n",nameSpace,@"true"];
	
	//concepto
	[soap appendFormat:@"<n3:concepto i:type=\":\" xmlns:n3=%@>",nameSpace];
	[soap appendFormat:@"<n4:codigo i:type=\"n4:string\" xmlns:n4=%@>%@</n4:codigo>\n",nameSpace2,concepto.codigo ];
	[soap appendFormat:@"<n5:nombre i:type=\"n5:string\" xmlns:n5=%@>%@</n5:nombre>\n",nameSpace2,concepto.nombre];
	[soap appendFormat:@"</n3:concepto>"];
	
	//cuenta origen
	[soap appendFormat:@"<n6:cuentaOrigen i:type=\":\" xmlns:n6=%@>",nameSpace];
	[soap appendFormat:@"<n7:codigo i:type=\"n7:string\" xmlns:n7%@ >%@</n7:codigo>\n",nameSpace3,cuentaOrigen.codigo];
	[soap appendFormat:@"<n8:codigoMoneda i:type=\"n8:int\" xmlns:n8%@ >%i</n8:codigoMoneda>\n",nameSpace3,cuentaOrigen.codigoMoneda];
	[soap appendFormat:@"<n9:codigoTipoCuenta i:type=\"n9:string\" xmlns:n9%@ >%@</n9:codigoTipoCuenta>\n",nameSpace3,cuentaOrigen.codigoTipoCuenta];
	[soap appendFormat:@"<n10:ctaEspecial i:type=\"n10:boolean\" xmlns:n10%@ >%@</n10:ctaEspecial>\n",nameSpace3,cuentaOrigen.ctaEspecial?@"true":@"false"];
	[soap appendFormat:@"<n11:descripcionCortaTipoCuenta i:type=\"n11:string\" xmlns:n11%@ >%@</n11:descripcionCortaTipoCuenta>\n",nameSpace3,cuentaOrigen.descripcionCortaTipoCuenta];
	[soap appendFormat:@"<n12:descripcionLargaTipoCuenta i:type=\"n12:string\" xmlns:n12%@ >%@</n12:descripcionLargaTipoCuenta>\n",nameSpace3,cuentaOrigen.descripcionLargaTipoCuenta];
	[soap appendFormat:@"<n13:disponible i:type=\"n13:double\" xmlns:n13%@ >%d</n13:disponible>\n",nameSpace3,cuentaOrigen.disponible];
	[soap appendFormat:@"<n14:limite i:type=\"n14:string\" xmlns:n14%@ >%@</n14:limite>\n",nameSpace3,cuentaOrigen.limite];
	[soap appendFormat:@"<n15:numero i:type=\"n15:string\" xmlns:n15%@ >%@</n15:numero>\n",nameSpace3,cuentaOrigen.numero];
	[soap appendFormat:@"<n16:saldo i:type=\"n16:string\" xmlns:n16%@ >%@</n16:saldo>\n",nameSpace3,@"0.0"];
	[soap appendFormat:@"<n17:simboloMoneda i:type=\"n17:string\" xmlns:n17%@ >%@</n17:simboloMoneda>\n",nameSpace3,cuentaOrigen.simboloMoneda];
	[soap appendFormat:@"</n6:cuentaOrigen>"];
	
	[soap appendFormat:@"<n18:documento i:type=\"n18:string\" xmlns:n18=%@>%@</n18:documento>\n",nameSpace,cuentaDestino.cuit];
	[soap appendFormat:@"<n19:importe i:type=\"n19:string\" xmlns:n19=%@>%@</n19:importe>\n",nameSpace,importe];
	[soap appendFormat:@"<n20:propia i:type=\"n20:string\" xmlns:n20=%@>%@</n20:propia>\n",nameSpace,cuentaDestino.propia];
	[soap appendFormat:@"<n21:nombre i:type=\"n21:string\" xmlns:n21=%@>%@</n21:nombre>\n",nameSpace,cuentaDestino.nombre];
	[soap appendFormat:@"<n22:referencia i:type=\"n22:string\" xmlns:n22=%@>%@</n22:referencia>\n",nameSpace,referencia];
	[soap appendFormat:@"<n23:tarjeta i:type=\"n23:string\" xmlns:n23=%@>%@</n23:tarjeta>\n",nameSpace,self.tarjeta];
	//Datos de Titularidad para transferencias inmediatas
//	if (tInmediata) {
//		//completar datos titularidad
//		[soap appendFormat:@"<n23:titularidad i:type=\":\" xmlns:n23=%@>",nameSpace];
//		[soap appendFormat:@"<n24:nombreTitular i:type=\"n24:string\" xmlns:n24=%@>%@</n24:nombreTitular>\n",nameSpace,tInmediata.nombreTitular];
//		[soap appendFormat:@"<n25:nombreBanco i:type=\"n25:string\" xmlns:n25=%@>%@</n25:nombreBanco>\n",nameSpace,tInmediata.nombreBanco];
//		[soap appendFormat:@"<n26:fiidBanco i:type=\"n26:string\" xmlns:n26=%@>%@</n26:fiidBanco>\n",nameSpace,tInmediata.fiidBanco];
//		
//		//cuenta destino de titular
//		[soap appendFormat:@"<n27:cuentaDestino i:type=\":\" xmlns:n27=%@>",nameSpace3];
//		[soap appendFormat:@"<n28:codigo i:type=\"n28:string\" xmlns:n28%@ >%@</n28:codigo>\n",nameSpace3,tInmediata.cuentaDestino.codigo];
//		[soap appendFormat:@"<n29:codigoMoneda i:type=\"n29:int\" xmlns:n29%@ >%d</n29:codigoMoneda>\n",nameSpace3,tInmediata.cuentaDestino.codigoMoneda];
//		[soap appendFormat:@"<n30:codigoTipoCuenta i:type=\"n30:string\" xmlns:n30%@ >%@</n30:codigoTipoCuenta>\n",nameSpace3,tInmediata.cuentaDestino.codigoTipoCuenta];
//		if(cuentaDestino.ctaEspecial){
//			[soap appendFormat:@"<n31:ctaEspecial i:type=\"n31:boolean\" xmlns:n31%@ >%@</n31:ctaEspecial>\n",nameSpace3,@"true"];
//		}else {
//			[soap appendFormat:@"<n31:ctaEspecial i:type=\"n31:boolean\" xmlns:n31%@ >%@</n31:ctaEspecial>\n",nameSpace3,@"false"];
//		}
//		[soap appendFormat:@"<n32:descripcionCortaTipoCuenta i:type=\"n32:string\" xmlns:n32%@ >%@</n32:descripcionCortaTipoCuenta>\n",nameSpace3,tInmediata.cuentaDestino.descripcionCortaTipoCuenta];
//		[soap appendFormat:@"<n33:descripcionLargaTipoCuenta i:type=\"n33:string\" xmlns:n33%@ >%@</n33:descripcionLargaTipoCuenta>\n",nameSpace3,tInmediata.cuentaDestino.descripcionLargaTipoCuenta];
//		[soap appendFormat:@"<n34:disponible i:type=\"n34:double\" xmlns:n34%@ >%d</n34:disponible>\n",nameSpace3,tInmediata.cuentaDestino.disponible];
//		[soap appendFormat:@"<n35:limite i:type=\"n35:string\" xmlns:n35%@ >%@</n35:limite>\n",nameSpace3,tInmediata.cuentaDestino.limite];
//		[soap appendFormat:@"<n36:numero i:type=\"n36:string\" xmlns:n36%@ >%@</n36:numero>\n",nameSpace3,tInmediata.cuentaDestino.numero];
//		[soap appendFormat:@"<n37:saldo i:type=\"n37:string\" xmlns:n37%@ >%@</n37:saldo>\n",nameSpace3,@"0.0"];
//		[soap appendFormat:@"<n38:simboloMoneda i:type=\"n38:string\" xmlns:n38%@ >%@</n38:simboloMoneda>\n",nameSpace3,tInmediata.cuentaDestino.simboloMoneda];
//		[soap appendFormat:@"</n27:cuentaDestino>"];
//		
//		//lista cuits titular
//		//[soap appendFormat:@"<n39:cuits i:type=\":\" xmlns:n39=%@>",nameSpace];
//		//[soap appendFormat:@"<n40:codigo i:type=\"n40:string\" xmlns:n40%@ >%@</n40:codigo>\n",nameSpace,[tInmediata.cuits objectAtIndex:0]];
//		//[soap appendFormat:@"</n39:cuits>"];
//		[soap appendFormat:@"<n39:cuits i:type=\":\" xmlns:n39=%@>",nameSpace];
//		int i = 40;
//		for (NSString *c in tInmediata.cuits) {
//			[soap appendFormat:@"<n%i:codigo i:type=\"n%i:string\" xmlns:n%i%@ >%@</n%i:codigo>\n",i,i,i,nameSpace,c,i];
//			i++;
//		}
//		[soap appendFormat:@"</n39:cuits>"];
//		
//		[soap appendFormat:@"</n23:titularidad>"];
//	}
	
	
	//[soap autorelease];
	
	return soap;
}



@end
