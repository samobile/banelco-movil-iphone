//
//  Deuda.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Deuda.h"
#import "Util.h"
#import "WSUtil.h"
#import "Context.h"
#import "WS_ConsultarDeudas.h"
#import "WS_ListarIdentificacionesRecargaMovil.h"


@implementation Deuda

@synthesize codigoEmpresa, codigoRubro;

@synthesize descPantalla, descripcionUsuario, error, idAdelanto, idCliente;

@synthesize importe, importePermitido, monedaCodigo, monedaSimbolo, nombreEmpresa, nroFactura, otroImporte;

@synthesize tipoEmpresa, tipoPago, tituloIdentificacion, vencimiento, creator, datoAdicional, leyenda, agregadaManualmente;


- (NSString *) getDescripcion {

	NSString *codigo = @"";
	
	if (![@"TCIN" isEqualToString:self.codigoRubro] && ![@"TCRE" isEqualToString:self.codigoRubro]) {
		
		if ([self.idCliente length] > 8) {
			codigo = [NSString stringWithFormat:@"...%@", [self.idCliente substringFromIndex:[self.idCliente length] - 8]];
		} else {
			codigo = self.idCliente;
		}

	} else {
		
		codigo = [Util formatDigits:self.idCliente];
		
	}

	return [NSString stringWithFormat:@"%@ - %@\nVto.%@  %@%@", self.nombreEmpresa, codigo, self.vencimiento, self.monedaSimbolo, self.importe];
	
}

- (BOOL) equals:(id)otroObjecto {

	if (otroObjecto == self) {
		return YES;
	}
	if (![otroObjecto isKindOfClass:[Deuda class]]) {
		return NO;
	}
	
	Deuda *otraDeuda = (Deuda *)otroObjecto;
	BOOL retval = YES;
	
	if (self.codigoEmpresa && retval) {
		retval = [self.codigoEmpresa isEqualToString:otraDeuda.codigoEmpresa];
	}
	if (self.nroFactura && retval) {
		retval = [self.nroFactura isEqualToString:otraDeuda.nroFactura];
	}
	if (self.idCliente && retval) {
		retval = [self.idCliente isEqualToString:otraDeuda.idCliente];
	}
    if (self.importe && retval) {
		//retval = [self.importe isEqualToString:otraDeuda.importe];
        if ([self.importe length]>0 && [otraDeuda.importe length] > 0) {
            retval = [self.importe floatValue] == [otraDeuda.importe floatValue] ? YES : NO;
        }
        else {
            retval = NO;
        }
	}
    
	
	return retval;

}

+ (NSMutableArray *) borrarDeuda:(Deuda *)deuda en:(NSMutableArray *)deudas {

	NSMutableArray *newDeudas = [[NSMutableArray alloc] init];
	
	for (Deuda *d in deudas) {
		
		if (![d equals:deuda]) {
			[newDeudas addObject:d];
		}
		
	}
	
	return newDeudas;
	
}

+ (NSMutableArray *) getDeudas {

	WS_ConsultarDeudas * request = [[WS_ConsultarDeudas alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	
	NSMutableArray *deudas = [WSUtil execute:request];
	
	if (![deudas isKindOfClass:[NSError class]]) {
		
        context.deudas = deudas;//[deudas retain];
		
	}
	
	return deudas;
	
}

+ (NSMutableArray *) getDeudasConCodEmpresa:(NSString *)cod {
	
	WS_ListarIdentificacionesRecargaMovil * request = [[WS_ListarIdentificacionesRecargaMovil alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	request.codigo = cod;
	
	NSMutableArray *deudas = [WSUtil execute:request];
	
	return deudas;
	
}

-(NSString*) toSoapObject {
	
	NSMutableString* soap = [[NSMutableString alloc] init];
	
	/*NSString* nameSpace = @"\"http://deudas.consultas.mobile.services.pmctas.banelco.com\"";
	[soap appendFormat:@"<n1:agregadaManualmente i:type=\"n1:boolean\" xmlns:n1=%@>%@</n1:agregadaManualmente>\n",nameSpace,agregadaManualmente?@"true":@"false" ];
	[soap appendFormat:@"<n2:codigoEmpresa i:type=\"n2:string\" xmlns:n2=%@>%@</n2:codigoEmpresa>\n",nameSpace,codigoEmpresa];
	[soap appendFormat:@"<n3:codigoRubro i:type=\"n3:string\" xmlns:n3=%@>%@</n3:codigoRubro>\n",nameSpace,codigoRubro];
	[soap appendFormat:@"<n4:descPantalla i:type=\"n4:string\" xmlns:n4=%@>%@</n4:descPantalla>\n",nameSpace,descPantalla];
	[soap appendFormat:@"<n5:descripcionUsuario i:type=\"n5:string\" xmlns:n5=%@>%@</n5:descripcionUsuario>\n",nameSpace,descripcionUsuario];
	[soap appendFormat:@"<n6:error i:type=\"n6:string\" xmlns:n6=%@>%@</n6:error>\n",nameSpace,error];
	[soap appendFormat:@"<n7:idAdelanto i:type=\"n7:string\" xmlns:n7=%@>%@</n7:idAdelanto>\n",nameSpace,idAdelanto];
	[soap appendFormat:@"<n8:idCliente i:type=\"n8:string\" xmlns:n8=%@>%@</n8:idCliente>\n",nameSpace,idCliente];
	[soap appendFormat:@"<n9:importe i:type=\"n9:double\" xmlns:n9=%@>%@</n9:importe>\n",nameSpace,importe];
	[soap appendFormat:@"<n10:importePermitido i:type=\"n10:int\" xmlns:n10=%@>%i</n10:importePermitido>\n",nameSpace,importePermitido];
	[soap appendFormat:@"<n11:monedaCodigo i:type=\"n11:int\" xmlns:n11=%@>%i</n11:monedaCodigo>\n",nameSpace,monedaCodigo];
	[soap appendFormat:@"<n12:monedaSimbolo i:type=\"n12:string\" xmlns:n12=%@>%@</n12:monedaSimbolo>\n",nameSpace,monedaSimbolo];
	[soap appendFormat:@"<n13:nombreEmpresa i:type=\"n13:string\" xmlns:n13=%@>%@</n13:nombreEmpresa>\n",nameSpace,nombreEmpresa];
	[soap appendFormat:@"<n14:nroFactura i:type=\"n14:string\" xmlns:n14=%@>%@</n14:nroFactura>\n",nameSpace,nroFactura];
	[soap appendFormat:@"<n15:otroImporte i:type=\"n15:double\" xmlns:n15=%@>%@</n15:otroImporte>\n",nameSpace,otroImporte];
	[soap appendFormat:@"<n16:tipoEmpresa i:type=\"n16:string\" xmlns:n16=%@>%@</n16:tipoEmpresa>\n",nameSpace,tipoEmpresa];
	[soap appendFormat:@"<n17:tipoPago i:type=\"n17:int\" xmlns:n17=%@>%i</n17:tipoPago>\n",nameSpace,tipoPago];
	[soap appendFormat:@"<n18:tituloIdentificacion i:type=\"n18:string\" xmlns:n18=%@>%@</n18:tituloIdentificacion>\n",nameSpace,tituloIdentificacion];
	[soap appendFormat:@"<n19:vencimiento i:type=\"n19:string\" xmlns:n19=%@>%@</n19:vencimiento>\n",nameSpace,vencimiento];
	 */

	NSString* nameSpace = @"\"http://deudas.consultas.mobile.services.pmctas.banelco.com\"";
	[soap appendFormat:@"<n1:agregadaManualmente i:type=\"n1:boolean\" xmlns:n1=%@>%@</n1:agregadaManualmente>\n",nameSpace,agregadaManualmente?@"true":@"false" ];
	[soap appendFormat:@"<n2:codigoEmpresa i:type=\"n2:string\" xmlns:n2=%@>%@</n2:codigoEmpresa>\n",nameSpace,codigoEmpresa];
	[soap appendFormat:@"<n3:descPantalla i:type=\"n3:string\" xmlns:n3=%@>%@</n3:descPantalla>\n",nameSpace,descPantalla];
	[soap appendFormat:@"<n4:descripcionUsuario i:type=\"n4:string\" xmlns:n4=%@>%@</n4:descripcionUsuario>\n",nameSpace,descripcionUsuario];
	[soap appendFormat:@"<n5:error i:type=\"n5:string\" xmlns:n5=%@>%@</n5:error>\n",nameSpace,error];
	[soap appendFormat:@"<n6:idAdelanto i:type=\"n6:string\" xmlns:n6=%@>%@</n6:idAdelanto>\n",nameSpace,idAdelanto];
	[soap appendFormat:@"<n7:idCliente i:type=\"n7:string\" xmlns:n7=%@>%@</n7:idCliente>\n",nameSpace,idCliente];
	[soap appendFormat:@"<n8:importe i:type=\"n8:double\" xmlns:n8=%@>%@</n8:importe>\n",nameSpace,importe];
	[soap appendFormat:@"<n9:importePermitido i:type=\"n9:int\" xmlns:n9=%@>%i</n9:importePermitido>\n",nameSpace,importePermitido];
	[soap appendFormat:@"<n10:monedaCodigo i:type=\"n10:int\" xmlns:n10=%@>%i</n10:monedaCodigo>\n",nameSpace,monedaCodigo];
	[soap appendFormat:@"<n11:monedaSimbolo i:type=\"n11:string\" xmlns:n11=%@>%@</n11:monedaSimbolo>\n",nameSpace,monedaSimbolo];
	[soap appendFormat:@"<n12:nombreEmpresa i:type=\"n12:string\" xmlns:n12=%@>%@</n12:nombreEmpresa>\n",nameSpace,nombreEmpresa];
	[soap appendFormat:@"<n13:nroFactura i:type=\"n13:string\" xmlns:n13=%@>%@</n13:nroFactura>\n",nameSpace,nroFactura];
	[soap appendFormat:@"<n14:otroImporte i:type=\"n14:double\" xmlns:n14=%@>%@</n14:otroImporte>\n",nameSpace,otroImporte];
	[soap appendFormat:@"<n15:tipoEmpresa i:type=\"n15:string\" xmlns:n15=%@>%@</n15:tipoEmpresa>\n",nameSpace,tipoEmpresa];
	[soap appendFormat:@"<n16:tipoPago i:type=\"n16:int\" xmlns:n16=%@>%i</n16:tipoPago>\n",nameSpace,tipoPago];
	[soap appendFormat:@"<n17:tituloIdentificacion i:type=\"n17:string\" xmlns:n17=%@>%@</n17:tituloIdentificacion>\n",nameSpace,tituloIdentificacion];
	[soap appendFormat:@"<n18:vencimiento i:type=\"n18:string\" xmlns:n18=%@>%@</n18:vencimiento>\n",nameSpace,vencimiento];
	
	[soap autorelease];
	return soap;
	
}

- (id)copyWithZone:(NSZone *)zone
{
	Deuda *deudaInstanceCopy = [[Deuda allocWithZone: zone] init];

	deudaInstanceCopy.codigoEmpresa = [codigoEmpresa copy];
	deudaInstanceCopy.codigoRubro = [codigoRubro copy];
	deudaInstanceCopy.descPantalla = [descPantalla copy];
	deudaInstanceCopy.descripcionUsuario = [descripcionUsuario copy];
	deudaInstanceCopy.error = [error copy];
	deudaInstanceCopy.idAdelanto = [idAdelanto copy];
	deudaInstanceCopy.idCliente = [idCliente copy];
	deudaInstanceCopy.importe = [importe copy];
	deudaInstanceCopy.importePermitido = importePermitido;
	deudaInstanceCopy.monedaCodigo = monedaCodigo;
	deudaInstanceCopy.monedaSimbolo = [monedaSimbolo copy];
	deudaInstanceCopy.nombreEmpresa = [nombreEmpresa copy];
	deudaInstanceCopy.nroFactura = [nroFactura copy];
	deudaInstanceCopy.otroImporte = [otroImporte copy];
	deudaInstanceCopy.tipoEmpresa = [tipoEmpresa copy];
	deudaInstanceCopy.tipoPago = tipoPago;
	deudaInstanceCopy.tituloIdentificacion = [tituloIdentificacion copy];
	deudaInstanceCopy.vencimiento = [vencimiento copy];
	deudaInstanceCopy.creator = [creator copy];
	deudaInstanceCopy.datoAdicional = [datoAdicional copy];
	deudaInstanceCopy.leyenda = [leyenda copy];
	deudaInstanceCopy.agregadaManualmente = agregadaManualmente;
	
	return deudaInstanceCopy;
}



@end
