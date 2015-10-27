#import "EmpresasList.h"
#import "Context.h"
#import "Empresa.h"
#import "ExecutePagoTarjeta_Cuentas.h"
#import "UltimosPagosController.h"
#import "MenuBanelcoController.h"
#import "CommonUIFunctions.h"
#import "WaitingAlert.h"
#import "BuscarEmpresa.h"
#import "RubrosList.h"

#import "DeudasCodBarra.h"
#import "TipoDePagoController.h"
#import "BanelcoReaderViewController.h"

@implementation EmpresasList

@synthesize rubro, busqueda;
@synthesize alert;

int const EL_ULTIMOS_PAGOS = 0;
int const EL_PAGOS_TARJETA = 1;
int const EL_OTRAS_CUENTAS = 2;
int const EL_OTRAS_CUENTAS_COD = 3;


- (id)init {
    if ((self = [super init])) {
		/** Lista de entidades a filtrar (salvo en Ultimos Comprobantes) */
		paraFiltrar = [[NSArray alloc] initWithObjects:@"SUBE", nil];
    }
    return self;
}


- (id)initWithCodigoRubro:(NSString *)codRubro busqueda:(NSString *)filtro andTipoAccion:(BOOL)accion {
    if ((self = [self init])) {
		self.title = @"Elegí Empresa";
        self.rubro = codRubro;
		self.busqueda = filtro;
		tipoAccion = accion;
		
		listaEmpresas = nil;
    }
    return self;
}

- (id)initWithRubro:(Rubro *)_rubro busqueda:(NSString *)filtro andTipoAccion:(BOOL)accion {
    if ((self = [self init])) {
		if (_rubro) {
			self.title = _rubro.nombre? _rubro.nombre : @"Elegí Empresa";
			self.rubro = _rubro.codigo? _rubro.codigo : @"";
		} else {
			self.title = @"Elegí Empresa";
			self.rubro = @"";
		}

		self.busqueda = filtro;
		tipoAccion = accion;
		
		listaEmpresas = nil;
    }
    return self;
}
 

- (id)initWithRubro:(Rubro *)_rubro withEmpresas:(NSMutableArray *)empresas andTipoAccion:(BOOL)accion {
    if ((self = [self initWithRubro:_rubro busqueda:@"" andTipoAccion:accion])) {

		listaEmpresas = [self filtrarEmpresas:empresas];
		
    }
    return self;
}

- (id)initWithRubro:(Rubro *)_rubro withEmpresasDictionary:(NSMutableDictionary *)empresasDict andTipoAccion:(BOOL)accion {
    if ((self = [self initWithRubro:_rubro busqueda:@"" andTipoAccion:accion])) {
        listaEmpresas = [[NSMutableArray alloc] init];
        for (DeudasCodBarra *dcb in [empresasDict allValues]) {
            [listaEmpresas addObject:dcb.empresa];
        }
    }
    return self;
}

- (void)iniciarListado:(NSMutableArray *)result {
    
	self.sourceDictionary = [[NSMutableDictionary alloc] init];

	if (![result isKindOfClass:[NSError class]]) {
		
		self.sourceKeys = [[NSMutableArray alloc] init];
		for (Empresa *empresa in result) {
			
			[sourceDictionary setValue:empresa forKey:empresa.nombre];
			
		}
		
		self.sourceKeys = [[sourceDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
		
		if ([sourceKeys count] > 0) {
			self.filteredKeys = [NSArray arrayWithArray:self.sourceKeys];
			
			[tableView reloadData];
		} else {
			[CommonUIFunctions showAlert:@"No hay entidades para este rubro" withMessage:nil cancelButton:@"Cerrar" andDelegate:self];
		}
		
	} else if ([[[(NSError *)result userInfo] valueForKey:@"tipoError"] isEqualToString:@"LE"]) {
		
		//NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		//[CommonUIFunctions showAlert:@"Demasiados resultados" withMessage:errorDesc andCancelButton:@"Cerrar"];
		
		if (tipoAccion == EL_PAGOS_TARJETA) {
			Rubro *rubroT = [[Rubro alloc] init];
			rubroT.codigo = RUBRO_TARJETAS;
			rubroT.nombre = @"Tarjetas de Crédito";
			BuscarEmpresa *buscarEmpresa = [[BuscarEmpresa alloc] initWithType:BE_LIMITE tipoAccion:EL_PAGOS_TARJETA andRubro:rubroT];
			[[MenuBanelcoController sharedMenuController] pushScreen:buscarEmpresa];
		}
		else {
			BuscarEmpresa *buscarEmpresa = [[BuscarEmpresa alloc] initWithType:BE_LIMITE tipoAccion:EL_OTRAS_CUENTAS andRubro:nil];
			[[MenuBanelcoController sharedMenuController] pushScreen:buscarEmpresa];
		}
			
	} else {
		NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:@"Lista de empresas" withMessage:errorDesc andCancelButton:@"Cerrar"];
		
	}
	
}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	Context *context = [Context sharedContext];
	
    if (!context.deudas) {
        [Deuda getDeudas];
    }
    
	if (!listaEmpresas) {
		@try {
			
			NSMutableArray *empresas = [Empresa getEmpresas:self.rubro 
												  conFiltro:self.busqueda
											   soloConsulta:(tipoAccion == EL_ULTIMOS_PAGOS)];

			NSMutableArray *filtradas = [self filtrarEmpresas:empresas];
			
			[self iniciarListado:filtradas];
			
		}
		@catch (NSException * e) {
			// TODO
		}
	} else {
		
		[self iniciarListado:listaEmpresas];
		
	}

	
	[delegate accionFinalizada:TRUE];
}

- (NSMutableArray *)filtrarEmpresas:(NSMutableArray *)empresas {
	
	if ([empresas isKindOfClass:[NSError class]]) {
		return empresas;
	}
	
	BOOL soloConsulta = (tipoAccion == EL_ULTIMOS_PAGOS) || (tipoAccion == EL_OTRAS_CUENTAS_COD);
	
	// Si es para "Mis Comprobantes" muestro todas
	if(soloConsulta) {
		return empresas;
		
		// Si no, filtro algunas especificas
	} else {
		NSMutableArray *filtradas = [[NSMutableArray alloc] init];
		
		for (Empresa *empresa in empresas) {
			
			BOOL agregar = YES;
			for(int j=0; j < [paraFiltrar count]; j++) {
				if([[empresa.codigo uppercaseString] isEqualToString:[paraFiltrar objectAtIndex:j]]) {
					agregar = NO;
					continue;
				}
			}
			if(agregar)
				[filtradas addObject:empresa];
			
		}
		
		return filtradas;
	}
			
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[searchBar resignFirstResponder];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Empresa *empresaSelected = [self getItem:indexPath.row];

	if (tipoAccion == EL_ULTIMOS_PAGOS) {
		UltimosPagosController *ultimosPagos = [[UltimosPagosController alloc] initWithEmpresa:empresaSelected];
		[[MenuBanelcoController sharedMenuController] pushScreen:ultimosPagos];
		
	} else if (tipoAccion == EL_PAGOS_TARJETA || tipoAccion == EL_OTRAS_CUENTAS) {
		ExecutePagoTarjeta_Cuentas *executePTCuentas = [[ExecutePagoTarjeta_Cuentas alloc] initWithEmpresa:empresaSelected andNextAction:tipoAccion];
		alert = [[WaitingAlert alloc] init];
		[self.view addSubview: alert];
		
		//[alert startWithSelector:@"execute" fromTarget:executePTCuentas];
		[alert startWithSelector:@"execute" fromTarget:executePTCuentas andFinishSelector:@"finishAlert" formTarget:self];
	//	[executePTCuentas execute];
		
	}
    else if (tipoAccion == EL_OTRAS_CUENTAS_COD) {
        alert = [[WaitingAlert alloc] init];
        [self.view addSubview: alert];
        [alert startWithSelector:@"obtenerDeudaBarra" fromTarget:self andFinishSelector:@"finishAlert" formTarget:self];
        
    }
	
}

- (void)obtenerDeudaBarra {
    Empresa *empresaSelected = [self getItem:[tableView indexPathForSelectedRow].row];
    id res = nil;
    if (!empresaSelected) {
        return;
    }
    res = [BanelcoReaderViewController getDeudasConCodigo:empresaSelected.codigoBarra yEmpresa:empresaSelected.codigo];
    if (!res) {
        [CommonUIFunctions showAlert:@"Avisos" withMessage:@"En este momento no se puede realizar la operación. Reintenta más tarde." cancelButton:@"Aceptar" andDelegate:nil];
    }
    else if (res && [res isKindOfClass:[NSError class]]) {
        NSString *errorCode = [[(NSError *)res userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        else {
            NSString *errorDesc = [[(NSError *)res userInfo] valueForKey:@"description"];
            if ([errorDesc rangeOfString:@"45"].location != NSNotFound) {
                errorDesc = @"Actualmente esta empresa no está disponible en PagoMisCuentas (código 45).";
            }
            else if ([errorDesc rangeOfString:@"47"].location != NSNotFound) {
                errorDesc = @"En este momento no es posible encontrar tu factura. Por favor intenta más tarde (código 47).";
            }
            else if ([errorDesc rangeOfString:@"44"].location != NSNotFound) {
                errorDesc = @"El código de barras es erróneo. Por favor intenta nuevamente. Si el problema persiste realiza el pago a través del buscador de empresas (código 44).";
            }
            [CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Aceptar" andDelegate:nil];
        }
    }
    else {
        NSMutableDictionary *dict = (NSMutableDictionary *)res;
        if ([[dict allKeys] count] == 1) {
            //ir al pago
            DeudasCodBarra *dcb = [[dict allValues] objectAtIndex:0];
            Deuda *d = dcb.deuda;
            if (!d) {
                [CommonUIFunctions showAlert:@"Avisos" withMessage:@"En este momento no se puede realizar la operación. Reintenta más tarde." cancelButton:@"Aceptar" andDelegate:nil];
            }
            else {
                [self performSelectorOnMainThread:@selector(irAPagoConDeuda:) withObject:d waitUntilDone:NO];
            }
            
        }
    }
    
    
    
    
}

- (void)irAPagoConDeuda:(Deuda *)d {
    TipoDePagoController *deudaController = [[TipoDePagoController alloc] initWithDeuda:d forImporteTotal:YES];
    [[MenuBanelcoController sharedMenuController] pushScreen:deudaController];
}

- (void) dismissAll{
	[searchBar resignFirstResponder];
}

- (void) finishAlert{
	[alert detener];
}

- (void)screenWillBeBack {
	if ([self.sourceDictionary count] == 0) {
		[[MenuBanelcoController sharedMenuController] volver];
	}
}

- (void)dealloc {
	[alert release];
	[rubro release];
	self.busqueda = nil;
	[paraFiltrar release];
    [super dealloc];
}


@end
