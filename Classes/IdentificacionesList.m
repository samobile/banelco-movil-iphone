//
//  IdentificacionesList.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IdentificacionesList.h"
#import "EmpresasList.h"
#import "NuevaIdentificacionForm.h"
#import "MenuBanelcoController.h"
#import "TipoDePagoController.h"
#import "CommonUIFunctions.h"
#import "DatoAdicionalForm.h"

@implementation IdentificacionesList
@synthesize items;
@synthesize empresa;
@synthesize tabla;


- (id)initWithTitle:(NSString *)title forEmpresa:(Empresa *)_empresa {
	
    if ((self = [super init])) {
		self.title = title;
		items = nil;
		tabla = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
		tabla.dataSource = self;
		tabla.backgroundColor = [UIColor clearColor];
		tabla.delegate = self;
		[self.view addSubview:tabla];
		empresa = _empresa;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title andItems:(NSMutableArray *)_items forEmpresa:(Empresa *)_empresa {
	
    if ((self = [super init])) {
		self.title = title;
		items = _items;
		empresa = _empresa;
		tabla = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
		tabla.backgroundColor = [UIColor clearColor];
		tabla.dataSource = self;
		tabla.delegate = self;
		[self.view addSubview:tabla];
    }
    return self;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
-(void) viewDidLoad{
	
	[self.tabla reloadData];
}


- (void)accionWithDelegate:(WheelAnimationController *)delegate {
		
	
	[delegate accionFinalizada:TRUE];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return items? [items count] : 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellEditingStyleDelete];
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.backgroundColor = [UIColor clearColor];
    }
	
	cell.textLabel.text = [items objectAtIndex:indexPath.row];
    
    return cell;
	
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.row < [items count] - 1) {

		@try {
			
			if (empresa.tipoPago == TIPO_PAGO_CON_FACTURA) {
				
				[self pagosConFactura:[items objectAtIndex:indexPath.row]];
				
			} else if (empresa.tipoPago == TIPO_PAGO_SIN_DEUDA_ADIC) {
				
				[self tipo_Pago_Sin_Deuda_Adic:[items objectAtIndex:indexPath.row]];
				
			} else {
				
				[self pagoSinFactura:[items objectAtIndex:indexPath.row]];
				
			}
			
		}
		@catch (NSException * e) {
			
		}
		
	} else { // Otro
		
		NuevaIdentificacionForm *pagosTarjetaForm = [[NuevaIdentificacionForm alloc] initWithTitle:[NSString stringWithFormat:@"%@", empresa.tituloIdentificacion] 
																						andEmpresa:empresa];
		[[MenuBanelcoController sharedMenuController] pushScreen:pagosTarjetaForm];
		
	}
	
}


/**
 * Pagos con tarjeta cuando la empresa tiene facturas
 * */
- (void) pagosConFactura:(NSString *)identificador {
	
	PagosListController *pagosList;
	
	// Obtengo las deudas del cliente
	NSMutableArray *deudas = [empresa getDeudasTarjeta:identificador];
	
	if (deudas) {
		
		pagosList = [[PagosListController alloc] initWithDeudas:deudas];
		[[MenuBanelcoController sharedMenuController] pushScreen:pagosList];
		
	} else {
		
		[CommonUIFunctions showAlert:@"Al momento no contamos con información de tus facturas pendientes de pago" 
						 withMessage:nil andCancelButton:@"Cerrar"];

	}
}

/**
 * Pagos con tarjeta cuando la empresa requiere el ingreso de un dato adicional
 * y no tiene facturas
 * */
- (void) tipo_Pago_Sin_Deuda_Adic:(NSString *)identificador  {
	
	DatoAdicionalForm *datoAdicionalForm = [[DatoAdicionalForm alloc] initForEmpresa:empresa withIdCliente:identificador];
	[[MenuBanelcoController sharedMenuController] pushScreen:datoAdicionalForm];

}

/**
 * Pagos con tarjeta cuando la empresa no tiene facturas
 * */
- (void) pagoSinFactura:(NSString *)identificador {
	
	@try {
			
		Deuda *deuda = [[Deuda alloc] init];
		deuda.codigoEmpresa = empresa.codigo;
		deuda.idCliente = identificador;
		deuda.monedaCodigo = empresa.codMoneda;
		deuda.nombreEmpresa = empresa.nombre;
		deuda.importe = @"";
		deuda.vencimiento = @"";
		deuda.codigoRubro = empresa.rubro;
		deuda.monedaSimbolo = empresa.simboloMoneda;
		deuda.tipoPago = empresa.tipoPago;
		deuda.importePermitido = empresa.importePermitido;
		deuda.tipoEmpresa = empresa.tipoEmpresa;
		deuda.datoAdicional = empresa.datoAdicional;
		deuda.leyenda = @"";
		deuda.agregadaManualmente = TRUE;
		// Datos que no estan, pero se pueden pasar en vacío si es pago sin factura
		deuda.descPantalla = @"";
		deuda.descripcionUsuario = @"";
		deuda.error = @"";
		deuda.idAdelanto = deuda.leyenda;
		deuda.nroFactura = @"";
		deuda.tituloIdentificacion = @"";
		
		Context *context = [Context sharedContext];
		context.selectedDeuda = deuda;
				
		TipoDePagoController *deudaController = [[TipoDePagoController alloc] initWithDeuda:deuda forImporteTotal:NO];
		[[MenuBanelcoController sharedMenuController] pushScreen:deudaController];
			
	} @catch (NSException *e) {
		[CommonUIFunctions showAlert:@"Excepcion en Pago sin factura." 
						 withMessage:nil andCancelButton:@"Cerrar"];
	}
	
}



- (void)dealloc {
	[items release];
	[tabla release];
	[empresa release];
    [super dealloc];
}


@end
