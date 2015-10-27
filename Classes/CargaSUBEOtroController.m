//
//  CargaSUBEOtroController.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CargaSUBEOtroController.h"
#import "CargaSUBEImporteController.h"
#import "MenuBanelcoController.h"
#import "Deuda.h"
#import "Empresa.h"
#import "CommonUIFunctions.h"


@implementation CargaSUBEOtroController

@synthesize listaTarjetas, tarjetas;

#pragma mark -
#pragma mark View lifecycle

- (id)init {
    if ((self = [super init])) {
		self.title = @"SUBE";
		
    }
    return self;
}

- (void) crearTextView {
	
	CGRect frameText = CGRectMake(12, 240, 296, 317 - 250);
	UITextView *textView = [[UITextView alloc] initWithFrame:frameText];
	textView.backgroundColor = [UIColor clearColor];
	textView.text = @"Para registrar otros números o cambio de compañía de los existentes deberás acceder a pagomiscuentas.com o al canal habilitado por tu Banco.";
	textView.userInteractionEnabled = NO;
	textView.editable = NO;
	textView.autocorrectionType = UITextAutocorrectionTypeNo;
	textView.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[self.view addSubview:textView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[self performSelectorOnMainThread:@selector(crearTextView) withObject:nil waitUntilDone:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tarjetas count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TarjetaSUBE";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellEditingStyleDelete ];
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
	//Carga el TableView
	NSString *texto = [(Deuda *)[self.tarjetas objectAtIndex:indexPath.row] descripcionUsuario];
	if (texto == nil || [texto isEqualToString:@""]) {
		texto = [(Deuda *)[self.tarjetas objectAtIndex:indexPath.row] idCliente];
	}
	cell.textLabel.text = texto;
	cell.textLabel.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CargaSUBEImporteController *i = [[CargaSUBEImporteController alloc] initWithTitle:@"SUBE" yEmpresaId:[(Deuda *)[tarjetas objectAtIndex:indexPath.row] codigoEmpresa]];
	i.idCliente = [(Deuda *)[tarjetas objectAtIndex:indexPath.row] idCliente];
	i.descCliente = [(Deuda *)[tarjetas objectAtIndex:indexPath.row] descripcionUsuario];
	[[MenuBanelcoController sharedMenuController] pushScreen:i];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

- (NSMutableArray *)getTarjetas {
	
	NSMutableArray *result = [[NSMutableArray alloc] init];
	Context *c = [Context sharedContext];
	
	//Como en BM Java, primero consulto las Deudas
	if (!c.deudas) {
		[Deuda getDeudas];
	}
	
	NSMutableArray *deudas = [Deuda getDeudasConCodEmpresa:@"SUBE"];
	if (deudas && [deudas isKindOfClass:[NSError class]]) {
		return nil;
	}
	if (deudas && [deudas count] > 0) {
		[result addObjectsFromArray:deudas];
	}
		
	return result;
}


- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	tarjetas = [self getTarjetas];
	
	if (tarjetas && [tarjetas count] > 0) {
		[listaTarjetas reloadData];
	}
	else {
		[CommonUIFunctions showAlert:@"Tarjetas SUBE" withMessage:@"Momentaneamente Ud. no posee tajetas SUBE registradas" cancelButton:@"Aceptar" andDelegate:self];
	}
	[delegate accionFinalizada:TRUE];
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
