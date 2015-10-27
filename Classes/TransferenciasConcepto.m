//
//  TransferenciasConcepto.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 26/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TransferenciasConcepto.h"
#import "MenuBanelcoController.h"
#import "TransferenciasRef.h"
#import "WS_ListarConceptos.h"
#import "WSUtil.h"
#import "CommonUIFunctions.h"
#import "WS_ConsultaTitularidad.h"

@implementation TransferenciasConcepto

@synthesize concepto, botonContinuar, listaConcepto, transfer, ejecutarConsultaTitularidad;
@synthesize lConcepto;

//internal

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (id) init {
	if ((self = [super init])) {
		self.title = @"A Otras Ctas. Agendadas";
	}
	ejecutarConsultaTitularidad = YES;
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    if (![Context sharedContext].personalizado) {
        lConcepto.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
    }
    
	lConcepto.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
	//CGRect r =  CGRectMake(20, 55, 280, 150);
//	concepto = [[UIPickerView alloc] init];
//	concepto.frame = r;
//	concepto.backgroundColor = [UIColor clearColor];
//	concepto.showsSelectionIndicator = TRUE;
//	concepto.delegate = self;
//	
//	[self.view addSubview:concepto];
	
	
//	listaConcepto = [[NSMutableArray alloc] init];
//	
//	[listaConcepto addObject:@"Alquileres"];
//	[listaConcepto addObject:@"Cuota"];
//	[listaConcepto addObject:@"Expensas"];
	
	//[concepto selectRow:1 inComponent:0 animated:NO];
    
    if (IS_IPHONE_5) {
        botonContinuar.frame = CGRectMake(botonContinuar.frame.origin.x, botonContinuar.frame.origin.y + 15, botonContinuar.frame.size.width, botonContinuar.frame.size.height);
    }
}

- (IBAction)continuar {
	TransferenciasRef *tr = [[TransferenciasRef alloc] init];
	self.transfer.concepto = [listaConcepto objectAtIndex:[concepto selectedRowInComponent:0]];
	tr.transfer = self.transfer;
	//tr.tInmediata = self.tInmediata;
	[[MenuBanelcoController sharedMenuController] pushScreen:tr];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
	return [listaConcepto count];
	
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
	return [(BaseModel *)[listaConcepto objectAtIndex:row] nombre];
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    UILabel* tView = (UILabel*)view;
//    if (!tView){
//		CGRect frame = CGRectMake(0.0, 0.0, 270, 32);
//		tView = [[[UILabel alloc] initWithFrame:frame] autorelease];
//		[tView setTextAlignment:UITextAlignmentLeft];
//		[tView setBackgroundColor:[UIColor clearColor]];
//		if (![Context sharedContext].personalizado) {
//            [tView setFont:[UIFont fontWithName:@"BanelcoBeau-Bold" size:16]];
//        }
//        else {
//            [tView setFont:[UIFont boldSystemFontOfSize:16]];
//        }
//    }
//    tView.text = [(BaseModel *)[listaConcepto objectAtIndex:row] nombre];
//    return tView;
//}


- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	//Transferencias Inmediatas: Consulta Titularidad
	if (ejecutarConsultaTitularidad) {
		ejecutarConsultaTitularidad = NO;
		WS_ConsultaTitularidad *requestT = [[WS_ConsultaTitularidad alloc] init];
		requestT.userToken = [[Context sharedContext] getToken];
		requestT.cuentaOrigen = transfer.cuentaOrigen;
		requestT.cbu = [NSString stringWithFormat:@"%@",[transfer.cuentaDestino codigo]];
		BOOL inmediata = YES;
		id resultT = [WSUtil execute:requestT];
		[requestT release];
		if ([resultT isKindOfClass:[NSError class]]) {
            
            NSString *errorCode = [[(NSError *)resultT userInfo] valueForKey:@"faultCode"];
            if ([errorCode isEqualToString:@"ss"]) {
                return;
            }
            
			NSString *errorDesc = [[(NSError *)resultT userInfo] valueForKey:@"description"];
			if ([errorDesc isEqualToString:@"65"]) {
				inmediata = NO;
			}
//			else if ([devCode isEqualToString:@"36"]) {
//				[CommonUIFunctions showAlert:self.title withMessage:@"No es posible efectuar la operación seleccionada. Por favor, verifique que el CBU ingresado sea correcto y que la cuenta origen y CBU destino sean de igual moneda" cancelButton:@"Volver" andDelegate:self];
//				[delegate accionFinalizada:TRUE];
//				return;
//			}
			else {
//				NSString *errorDesc = [[(NSError *)resultT userInfo] valueForKey:@"description"];
				[CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
				[delegate accionFinalizada:TRUE];
				return;
			}
		}
		if (inmediata) {
			[transfer setTInmediata:(TitularidadMobileDTO*)resultT];
		}
		else {
			transfer.tInmediata = nil;
		}
	}
	
	//Consulta Conceptos
	Context *c = [Context sharedContext];
	if (c.conceptos) {
		self.listaConcepto = c.conceptos;
		[concepto reloadAllComponents];
	}
	else {
	
		WS_ListarConceptos *request = [[WS_ListarConceptos alloc] init];
		request.userToken = [[Context sharedContext] getToken];
		id result = [WSUtil execute:request];
		[request release];
		if ([result isKindOfClass:[NSError class]]) {
            NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
            if ([errorCode isEqualToString:@"ss"]) {
                return;
            }
			NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
			[CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		
		}
		else if (result && [result count] > 0) {
			self.listaConcepto = (NSMutableArray *)result;
			c.conceptos = self.listaConcepto;
			[concepto reloadAllComponents];
		}
		else {
			[CommonUIFunctions showAlert:self.title withMessage:@"No hay Conceptos" cancelButton:@"Volver" andDelegate:self];
		}
	}
	//Fix Bug que permitia continuar a la siguiente pagina antes de seleccionar un concepto
	botonContinuar.userInteractionEnabled = YES;
	
	[delegate accionFinalizada:TRUE];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	//[tInmediata release];
	[lConcepto release];
	
    [super dealloc];
}


@end
