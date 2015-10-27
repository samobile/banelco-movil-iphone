//
//  CargaCelularPago.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CargaCelularPago.h"
#import "CargaCelularResultado.h"
#import "MenuBanelcoController.h"
#import "Empresa.h"
#import "WS_RealizarPago.h"
#import "WSUtil.h"
#import "Ticket.h"
#import "CommonUIFunctions.h"
#import "WaitingAlert.h"

@implementation CargaCelularPago

@synthesize botonPagar, importe, empresa, idCliente, descCliente, selectedCuenta;

WaitingAlert *waiting;


- (id) initWithTitle:(NSString *)t {
	if ((self = [super init])) {
		self.title = t;
		self.botonPagar = [[UIButton alloc] init];
        self.botonPagar.accessibilityLabel = @"Pagar";
		[self.botonPagar setBackgroundImage:[UIImage imageNamed:@"btn_pagar.png"] forState:UIControlStateNormal];
		[self.botonPagar setBackgroundImage:[UIImage imageNamed:@"btn_pagarselec.png"] forState:UIControlStateHighlighted];
		[self.botonPagar addTarget:self action:@selector(pagar) forControlEvents:UIControlEventTouchUpInside];
		
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	waiting = [[WaitingAlert alloc] init];
	[self.view addSubview:waiting];
	
	[self iniciar];

	//Carga Info
	/*
	int y = 20;
	int x = 20;
	int space = 10;
	NSString *str;
	
	y = space + [CommonUIFunctions addTextToView:self.view boldText:self.empresa.nombre normalText:nil xPos:x yPos:y];
	
	if (self.descCliente != nil && ![self.descCliente isEqualToString:@""]) {
		str = [NSString stringWithFormat:@"%@",self.descCliente];
	}
	else {
		str = [NSString stringWithFormat:@"%@",self.idCliente];
	}
	y = space + [CommonUIFunctions addTextToView:self.view boldText:str	normalText:nil xPos:x yPos:y];
	
	str = [NSString stringWithFormat:@"Importe %@ %@",selectedCuenta.simboloMoneda,[Util formatSaldo:self.importe]];
	y = space + [CommonUIFunctions addTextToView:self.view boldText:str normalText:nil xPos:x yPos:y];
	
	//y = space + [CommonUIFunctions addTextToView:self.view boldText:nil normalText:@"Fecha Vto.:" xPos:x yPos:y];
	
	str = [NSString stringWithFormat:@"Débito %@", [selectedCuenta getDescripcion]];
	y = space + [CommonUIFunctions addTextToView:self.view boldText:nil	normalText:str xPos:x yPos:y];
	 */
	
	int limite = 260;
	self.tableView.frame = CGRectMake(5, 5, 310, limite - 5);
	
	self.botonPagar.frame = CGRectMake(109, 265, 102, 32);
	[self.view addSubview:self.botonPagar];
	
	[self.tableView reloadData];
	
}

- (void)iniciar {
	
	// Empresa
	[titulos addObject: @"Empresa"];
	[datos addObject: self.empresa.nombre];

	// Importe
	[titulos addObject: @"Importe"];
	[datos addObject: [NSString stringWithFormat:@"%@ %@",selectedCuenta.simboloMoneda,[Util formatSaldo:self.importe]]];
	
	// Descripcion cliente
	[titulos addObject: @"ID"];
	if (self.descCliente != nil && ![self.descCliente isEqualToString:@""]) {
		[datos addObject: self.descCliente];
	} else {
		[datos addObject: self.idCliente];
	}
	
	// Debito
	[titulos addObject: @"Débito"];
	[datos addObject: [selectedCuenta getDescripcion]];
	
}


- (void)ejecutarPago {
    
	Deuda *deuda = [[Deuda alloc] init];
	deuda.codigoEmpresa = self.empresa.codigo;
	deuda.idCliente = self.idCliente;
	deuda.monedaCodigo = self.empresa.codMoneda;
	deuda.nombreEmpresa = self.empresa.nombre;
	deuda.importe = [self.importe stringByReplacingOccurrencesOfString:@"," withString:@"."];
	deuda.vencimiento = @"";
	deuda.codigoRubro = self.empresa.rubro;
	deuda.monedaSimbolo = self.empresa.simboloMoneda;
	deuda.tipoPago = self.empresa.tipoPago;
	deuda.importePermitido = self.empresa.importePermitido;
	deuda.tipoEmpresa = self.empresa.tipoEmpresa;
	deuda.datoAdicional = self.empresa.datoAdicional;
	deuda.leyenda = @"";
	deuda.agregadaManualmente = TRUE;
	deuda.descPantalla = @"";
	deuda.descripcionUsuario = @"";
	deuda.error = @"";
	deuda.idAdelanto = @"";
	deuda.nroFactura = @"";
	deuda.tituloIdentificacion = @"";
	deuda.otroImporte = [self.importe stringByReplacingOccurrencesOfString:@"," withString:@"."];
	
	//Ejecuta WS RealizarPago
	WS_RealizarPago *request = [[WS_RealizarPago alloc] init];
	request.userToken = [[Context sharedContext] getToken];
	request.deuda = deuda;
	request.codCuenta = self.selectedCuenta.codigo;
	
	id result = [WSUtil execute:request];
	
	[deuda release];
	
	//[waiting detener];
	
	if ([result isKindOfClass:[NSError class]]) {
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:@"Recarga Celular" withMessage:errorDesc cancelButton:@"Cerrar" andDelegate:nil];
		return;
	}
	
	

	CargaCelularResultado *r = [[CargaCelularResultado alloc] initWithTitle:@"Carga Realizada" andTicket:(Ticket *)result];
	r.importe = self.importe;
	if (self.descCliente != nil && ![self.descCliente isEqualToString:@""]) {
		r.descCliente = [NSString stringWithFormat:@"%@",self.descCliente];
	}
	else {
		r.descCliente = [NSString stringWithFormat:@"%@",self.idCliente];
	}
	r.cuenta = self.selectedCuenta;
	r.idCliente = self.idCliente;
	r.empresa = self.empresa;
	[[MenuBanelcoController sharedMenuController] pushScreen:r];
	
}

- (IBAction)pagar {
	
	[waiting startWithSelector:@"ejecutarPago" fromTarget:self];
	
}



- (void)dealloc {
	
	[botonPagar release];
	[importe release];
	[empresa release];
	[idCliente release]; 
	[descCliente release]; 
	[selectedCuenta release];
	
    [super dealloc];
}


@end
