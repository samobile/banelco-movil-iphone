
#import "Empresa.h"
#import "WS_ListarEmpresas.h"
#import "WS_ListarEmpresasPrepagos.h"
#import "WS_ListarIdentificaciones.h"
#import "WS_ConsultarUltimosPagos.h"
#import "WS_ObtenerDeudaEmpresa.h"
#import "WS_BuscarEmpresa.h"
#import "WSUtil.h"

@implementation Empresa

@synthesize codigo, nombre, importePermitido, tipoPago, tipoEmpresa;
@synthesize codMoneda, simboloMoneda, soloConsulta;
@synthesize datoAdicional, tituloIdentificacion, rubro;
@synthesize datosPrePago, nroLeyenda, Id; //Empresa Prepago
@synthesize nroSecuencia, codigoBarra; // Paginado


// Tipos Empresa

NSString * const TIPO_CINES = @"C";

NSString * const TIPO_AFIP = @"F";

NSString * const TIPO_MONOTRIBUTO = @"M";

NSString * const TIPO_RENTAS = @"R";

NSString * const TIPO_EMPRESA_MIXTA = @"T";

NSString * const TIPO_PREPAGO_PES = @"P";

// Tipos Pago

int const TIPO_PAGO_CON_DEUDA = 0;

int const TIPO_PAGO_SIN_DEUDA = 1;

int const TIPO_PAGO_SIN_DEUDA_ADIC = 2;

int const TIPO_PAGO_CON_FACTURA = 3;

int const TIPO_PAGO_MIXTO = 4;

// Importe Permitido

int const IMPORTE_IGUAL_DEUDA = 0;

int const IMPORTE_MAYORIGUAL_DEUDA = 1;

int const IMPORTE_NOIGUAL_DEUDA = 2;


// Obtiene todas las empresas
+ (NSMutableArray *) getEmpresas:(NSString *)rubro conFiltro:(NSString *)filtro soloConsulta:(BOOL)soloConsulta {
	
	Context *context = [Context sharedContext];
	NSMutableArray *empresas = [[NSMutableArray alloc] init];
	BOOL traer = TRUE;
	int indPagina = 0;
	
	WS_ListarEmpresas * request = [[WS_ListarEmpresas alloc] init];
	request.userToken = [context getToken];
	request.rubro = rubro;
	// TODO agregar filtro de busqueda
	request.busqueda = filtro;
	request.codBanco = context.banco.idBanco;
	request.pagina = [NSNumber numberWithInt:indPagina];
	request.soloConsulta = [NSNumber numberWithBool:soloConsulta];
	
	while (traer) {
		
		NSMutableArray *pagina = [WSUtil execute:request];
		
		if (![pagina isKindOfClass:[NSError class]]) {
			
			if ([pagina count] > 0) {
				
				[empresas addObjectsFromArray:pagina];
				indPagina++;
				request.pagina = [NSNumber numberWithInt:indPagina];
				
				if ([[pagina objectAtIndex:0] nroSecuencia] == 99) {
					
					traer = FALSE;
					
				}
				
			} else {
				
				traer = FALSE;
				
			}
			
		} else {
			
			empresas = pagina;
			traer = FALSE;
			
		}

	}
	
	return empresas;
}

// Obtiene las empresas por pagina
+ (NSArray *) getEmpresas:(NSString *)rubro pagina:(int)pagina soloConsulta:(BOOL)soloConsulta {
	
	WS_ListarEmpresas * request = [[WS_ListarEmpresas alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	
	request.rubro = rubro;
	
	request.codBanco = context.banco.idBanco;
	
	request.pagina = [NSNumber numberWithInt:pagina];
	
	request.soloConsulta = [NSNumber numberWithBool:soloConsulta];
	
	NSMutableArray *empresas = [WSUtil execute:request];
	
	return empresas;
}

+ (NSMutableArray *) getEmpresasPrepagos:(NSString *)rubro {
	
	WS_ListarEmpresasPrepagos * request = [[WS_ListarEmpresasPrepagos alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	
	request.rubro = rubro;
	
	request.codBanco = context.banco.idBanco;
	
	NSMutableArray *empresas = [WSUtil execute:request];
	
	return empresas;
}

+ (Empresa *) parse:(GDataXMLElement *)soapObject forSecuencia:(int)secuencia {
	
	Empresa *empresa = [[Empresa alloc] init];
	
	empresa.codMoneda = [WSUtil getIntegerProperty:@"codMoneda" ofSoap:soapObject];
	
	empresa.codigo = [WSUtil getStringProperty:@"codigo" ofSoap:soapObject];
	
	empresa.datoAdicional = [WSUtil getStringProperty:@"datoAdicional" ofSoap:soapObject];
	
	empresa.datosPrePago = [WSUtil getIntegerProperty:@"datosPrePago" ofSoap:soapObject];
	
	empresa.Id = [WSUtil getStringProperty:@"id" ofSoap:soapObject];
	
	empresa.importePermitido = [WSUtil getIntegerProperty:@"importePermitido" ofSoap:soapObject];
	
	empresa.nombre = [WSUtil getStringProperty:@"nombre" ofSoap:soapObject];
	
	empresa.nroLeyenda = [WSUtil getIntegerProperty:@"nroLeyenda" ofSoap:soapObject];
	
	empresa.rubro = [WSUtil getStringProperty:@"rubro" ofSoap:soapObject];
	
	empresa.simboloMoneda = [WSUtil getStringProperty:@"simboloMoneda" ofSoap:soapObject];
	
	empresa.soloConsulta = [WSUtil getBooleanProperty:@"soloConsulta" ofSoap:soapObject];
	
	empresa.tipoEmpresa = [WSUtil getStringProperty:@"tipoEmpresa" ofSoap:soapObject];
	
	empresa.tipoPago = [WSUtil getIntegerProperty:@"tipoPago" ofSoap:soapObject];
	
	empresa.tituloIdentificacion = [WSUtil getStringProperty:@"tituloIdentificacion" ofSoap:soapObject];
	
	empresa.nroSecuencia = secuencia;
	
	return empresa;
	
}

+ (Empresa *) parseForCodBarra:(GDataXMLElement *)soapObject withCodBarra:(NSString *)cod {
    
    Empresa *empresa = [[Empresa alloc] init];
    
    empresa.codMoneda = [WSUtil getIntegerProperty:@"codMoneda" ofSoap:soapObject];
    
    empresa.codigo = [WSUtil getStringProperty:@"codigo" ofSoap:soapObject];
    
    empresa.datoAdicional = [WSUtil getStringProperty:@"datoAdicional" ofSoap:soapObject];
    
    empresa.datosPrePago = [WSUtil getIntegerProperty:@"datosPrePago" ofSoap:soapObject];
    
    empresa.Id = [WSUtil getStringProperty:@"id" ofSoap:soapObject];
    
    empresa.importePermitido = [WSUtil getIntegerProperty:@"importePermitido" ofSoap:soapObject];
    
    empresa.nombre = [WSUtil getStringProperty:@"nombre" ofSoap:soapObject];
    
    empresa.nroLeyenda = [WSUtil getIntegerProperty:@"nroLeyenda" ofSoap:soapObject];
    
    empresa.rubro = [WSUtil getStringProperty:@"rubro" ofSoap:soapObject];
    
    empresa.simboloMoneda = [WSUtil getStringProperty:@"simboloMoneda" ofSoap:soapObject];
    
    empresa.soloConsulta = [WSUtil getBooleanProperty:@"soloConsulta" ofSoap:soapObject];
    
    empresa.tipoEmpresa = [WSUtil getStringProperty:@"tipoEmpresa" ofSoap:soapObject];
    
    empresa.tipoPago = [WSUtil getIntegerProperty:@"tipoPago" ofSoap:soapObject];
    
    empresa.tituloIdentificacion = [WSUtil getStringProperty:@"tituloIdentificacion" ofSoap:soapObject];
    
    empresa.nroSecuencia = 0;
    
    empresa.codigoBarra = cod;
    
    return empresa;
    
}

+ (Empresa *) parseEmpresaPrepago:(GDataXMLElement *)soapObject {
	
	Empresa *empresa = [[Empresa alloc] init];
	
	empresa.codigo = [WSUtil getStringProperty:@"codigo" ofSoap:soapObject];
	
	empresa.datosPrePago = [WSUtil getIntegerProperty:@"datosPrePago" ofSoap:soapObject];
	
	empresa.Id = [WSUtil getStringProperty:@"id" ofSoap:soapObject];
	
	empresa.nombre = [WSUtil getStringProperty:@"nombre" ofSoap:soapObject];
	
	empresa.nroLeyenda = [WSUtil getIntegerProperty:@"nroLeyenda" ofSoap:soapObject];
	
	return empresa;
}


- (NSMutableArray *) getUltimosPagos:(int)secuencia {
	
	WS_ConsultarUltimosPagos * request = [[WS_ConsultarUltimosPagos alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	
	request.codigo = codigo;
	
	request.secuencia = [NSNumber numberWithInt:secuencia];
	
	NSMutableArray *tickets = [WSUtil execute:request];
	
	return tickets;
	
}

- (NSMutableArray *) getDeudasTarjeta:(NSString *)idCliente {
	
	WS_ObtenerDeudaEmpresa * request = [[WS_ObtenerDeudaEmpresa alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	
	request.codigo = self.codigo;
	
	request.idCliente = idCliente;
	
	NSMutableArray *deudas = [WSUtil execute:request];
	
	return deudas;
	
}

- (NSMutableArray *) getIDs {
	
	WS_ListarIdentificaciones * request = [[WS_ListarIdentificaciones alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	
	request.codigo = codigo;
	
	NSMutableArray *IDs = [WSUtil execute:request];
	
	return IDs;
}


+ (Empresa *) getEmpresa:(NSString *)empresaId {
	
	WS_BuscarEmpresa * request = [[WS_BuscarEmpresa alloc] init];
	
	Context *context = [Context sharedContext];
	
	request.userToken = [context getToken];
	
	request.empresaId = empresaId;
	
	Empresa *empresa = [WSUtil execute:request];
	
	return empresa;
	
}

- (void)dealloc {
    self.codigoBarra = nil;
    [super dealloc];
}

@end
