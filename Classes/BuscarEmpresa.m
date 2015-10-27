//
//  BuscarEmpresa.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 10/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BuscarEmpresa.h"
#import "RubrosList.h"
#import "MenuBanelcoController.h"
#import "EmpresasList.h"
#import "CommonUIFunctions.h"

#import "BanelcoReaderViewController.h"
#import "WaitingAlert.h"
#import "DeudasCodBarra.h"
#import "TipoDePagoController.h"

@implementation BuscarEmpresa

@synthesize lblCampo, campo, btnRubros, btnScan, scanReader, alert;

int const BE_INICIAL = 0;
int const BE_LIMITE = 1;
int const BE_INICIAL_COD = 2;


- (id)initWithType:(int)_tipo tipoAccion:(int)accion andRubro:(Rubro *)_rubro {
    if ((self = [super initWithNibName:@"BuscarEmpresa" bundle:nil])) {
		tipo = _tipo;
		tipoAccion = accion;
		rubro = _rubro;
		codRubro = _rubro? _rubro.codigo : @"";
		
		if (tipo == BE_INICIAL || tipo == BE_INICIAL_COD) {
			self.title = @"Otras Cuentas";
			if (accion == EL_ULTIMOS_PAGOS) {
				self.title = @"Mis Comprobantes";
			}
		} else {
			
			if (_rubro) {
				self.title = _rubro.nombre;
			} else {
				self.title = @"Ingresá empresa a buscar";
			}

		}
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnScan.hidden = YES;
    if (tipo == BE_INICIAL_COD && [Context sharedContext].scanEnabled) {
        self.btnScan.hidden = NO;
    }
    
    if (![Context sharedContext].personalizado) {
        lblCampo.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        campo.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:16];
    }
	lblCampo.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	if (tipo == BE_LIMITE) {
		if (rubro) {
			//lblCampo.text = rubro.nombre;
			lblCampo.text = @"Ingresá empresa a buscar";
		} else {
			lblCampo.hidden = YES;
		}

		btnRubros.hidden = YES;
		
	} else {
		lblCampo.text = @"Buscar por Empresa";
	}

}

/*- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	if (tipo == BE_LIMITE) {
		[CommonUIFunctions showAlert:@"Buscar empresa" 
						 withMessage:@"La cantidad de resultados excede el límite. Por favor, ingrese una palabra de búsqueda." 
					 andCancelButton:@"Aceptar"];
	}
}*/


- (IBAction)buscar {

	[campo resignFirstResponder];
	
	NSString *filtro = nil;
	if ([campo.text length] > 0) {
		filtro = campo.text;
	}
	
	if([campo.text length] < 3) {
		[CommonUIFunctions showAlert:@"Buscar empresa" 
						 withMessage:@"Debes ingresar por lo menos tres caracteres para la búsqueda." 
					 andCancelButton:@"Aceptar"];
		return;
	}
	
	//EmpresasList *empresasList = [[EmpresasList alloc] initWithCodigoRubro:codRubro busqueda:filtro andTipoAccion:tipoAccion];
	EmpresasList *empresasList = [[EmpresasList alloc] initWithRubro:rubro busqueda:filtro andTipoAccion:tipoAccion];
	[[MenuBanelcoController sharedMenuController] pushScreen:empresasList];

}

- (IBAction)listarRubros {
	
	RubrosList *rubrosList = [[RubrosList alloc] initWithAction:tipoAccion];
	[[MenuBanelcoController sharedMenuController] pushScreen:rubrosList];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

	[self buscar];
	
}

- (void)dismissAll {
	if ([campo isFirstResponder]) {
		[campo resignFirstResponder];
	}
}

- (IBAction)escanearCodigo:(id)sender {
    self.scanReader = [[[BanelcoReaderViewController alloc] init] autorelease];
    self.scanReader.readerDelegate = self;
    
    UIWindow *win = [[[UIApplication sharedApplication] delegate] window];
    [self.scanReader startScanningInView:win];
}

- (void)finishReadingBarCodeWithResult:(NSString *)data {
    if (!data) {
        self.scanReader = nil;
        return;
    }
    
    self.alert = [[[WaitingAlert alloc] initWithH:20] autorelease];
    [self.view addSubview:alert];
    [alert startWithSelector:@"obtenerDeudasBarra" fromTarget:self andFinishSelector:@"finishAlert" formTarget:self];
    
}

- (void) finishAlert {
    [alert performSelectorOnMainThread:@selector(detener) withObject:nil waitUntilDone:NO];
    self.alert = nil;
}

- (void)obtenerDeudasBarra {
    id res = [self.scanReader getDeudasConCodigo];
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
        if ([[dict allKeys] count] > 1) {
            //cargar lista de empresas
            [self performSelectorOnMainThread:@selector(cargarListaEmpresas:) withObject:dict waitUntilDone:NO];
        }
        else if ([[dict allKeys] count] == 1) {
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
    self.scanReader = nil;
    NSLog(@"se ejecuta");
}

- (void)irAPagoConDeuda:(Deuda *)d {
    TipoDePagoController *deudaController = [[TipoDePagoController alloc] initWithDeuda:d forImporteTotal:YES];
    [[MenuBanelcoController sharedMenuController] pushScreen:deudaController];
}

- (void)cargarListaEmpresas:(NSMutableDictionary *)d {
    EmpresasList *empresasList = [[EmpresasList alloc] initWithRubro:nil withEmpresasDictionary:d andTipoAccion:EL_OTRAS_CUENTAS_COD];
    [[MenuBanelcoController sharedMenuController] pushScreen:empresasList];
}

- (void)dealloc {
    self.alert = nil;
    self.scanReader = nil;
    [super dealloc];
}


@end
