//
//  CargaCelularOtroController.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CargaCelularOtroController.h"
#import "CargaCelularImporteController.h"
#import "MenuBanelcoController.h"
#import "Deuda.h"
#import "Empresa.h"
#import "CommonUIFunctions.h"


@implementation CargaCelularOtroController

@synthesize listaCelular, celulares, tableContainer;

#pragma mark -
#pragma mark View lifecycle

- (id)init {
    if ((self = [super init])) {
        // Custom initialization
		//listaCelular = [[NSMutableArray alloc] init];
		self.title = @"Otro Número";
		
    }
    return self;
}

- (void) crearTextView {
	
    if ([Context sharedContext].nuevaRecarga) {
        return;
    }
    
	CGRect frameText = CGRectMake(12, IPHONE5_HDIFF(210), 296, 317 - 210);
	UITextView *textView = [[UITextView alloc] initWithFrame:frameText];
	textView.backgroundColor = [UIColor clearColor];
	if (![Context sharedContext].personalizado) {
        textView.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
    }
    //textView.text = @"";
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
    
    CGRect r = self.tableContainer.frame;
    r.size.height = IPHONE5_HDIFF(r.size.height);
    self.tableContainer.frame = r;
    
    r = self.listaCelular.frame;
    r.size.height = IPHONE5_HDIFF(r.size.height);
    self.listaCelular.frame = r;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [celulares count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Celular";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellEditingStyleDelete ];
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.backgroundColor = [UIColor clearColor];
    }
    NSString *texto = nil;
    if (indexPath.row == 0 && [Context sharedContext].nuevaRecarga) {
        texto = (NSString *)[self.celulares objectAtIndex:indexPath.row];
    }
    else {
        //Carga el TableView
        texto = [(Deuda *)[self.celulares objectAtIndex:indexPath.row] descripcionUsuario];
        if (texto == nil || [texto isEqualToString:@""]) {
            texto = [(Deuda *)[self.celulares objectAtIndex:indexPath.row] idCliente];
        }
    }
    if (![Context sharedContext].personalizado) {
        if (indexPath.row == 0 && [Context sharedContext].nuevaRecarga) {
            cell.textLabel.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:14];
        }
//        else {
//            cell.textLabel.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
//        }
        else {
            cell.textLabel.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:14];
        }
        
    }
    else {
        if (indexPath.row == 0 && [Context sharedContext].nuevaRecarga) {
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        }
    }
	cell.textLabel.text = texto;
	cell.textLabel.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	
	//cell.textLabel.text = [self.celulares objectAtIndex:indexPath.row];
	
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	//Consulta WS para obtener Empresa
	//Empresa *emp = [Empresa getEmpresa:[(Deuda *)[celulares objectAtIndex:indexPath.row] codigoEmpresa]];
	//if (emp) {
    
    if (indexPath.row == 0 && [Context sharedContext].nuevaRecarga && [Context sharedContext].usuario.esRestringido) {
        [CommonUIFunctions showRestrictedAlert:@"Otro Número" withDelegate:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    CargaCelularImporteController *i = [[CargaCelularImporteController alloc] initWithTitle:@"Otro Número" yEmpresaId:(indexPath.row == 0 && [Context sharedContext].nuevaRecarga ? nil : [(Deuda *)[celulares objectAtIndex:indexPath.row] codigoEmpresa])];
    if (indexPath.row == 0 && [Context sharedContext].nuevaRecarga) {
        i.idCliente = nil;
        i.descCliente = nil;
    }
    else {
        i.idCliente = [(Deuda *)[celulares objectAtIndex:indexPath.row] idCliente];
        i.descCliente = [(Deuda *)[celulares objectAtIndex:indexPath.row] descripcionUsuario];
    }
    
    [[MenuBanelcoController sharedMenuController] pushScreen:i];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	

}

- (NSMutableArray *)getOtrosCelulares {
	
	NSMutableArray *result = [[NSMutableArray alloc] init];
	Context *c = [Context sharedContext];
	
    if (c.nuevaRecarga) {
        //Opcion nuevo celular
        [result addObject:@"Nuevo"];
    }
    
	//Como en BM Java, primero consulto las Deudas
	if (!c.deudas) {
		[Deuda getDeudas];
	}
	
	if (c.carrierCodeNames) {
		for (NSString *ccode in c.carrierCodeNames) {
			NSMutableArray *deudas = [Deuda getDeudasConCodEmpresa:ccode];
			if (deudas && [deudas isKindOfClass:[NSError class]]) {
				continue;
			}
            else if ([deudas isKindOfClass:[NSError class]]) {
                NSString *errorCode = [[(NSError *)deudas userInfo] valueForKey:@"faultCode"];
                if ([errorCode isEqualToString:@"ss"]) {
                    return nil;
                }
            }
			if (deudas && [deudas count] > 0) {
				[result addObjectsFromArray:deudas];
			}
		}
		
	}
	return result;
}


- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	celulares = [self getOtrosCelulares];
	
	if (celulares && [celulares count] > 0) {
		[listaCelular reloadData];
	}
	else {
		[CommonUIFunctions showAlert:@"Otros Celulares" withMessage:@"Momentaneamente no posees otros números registrados" cancelButton:@"Aceptar" andDelegate:self];
	}
	[delegate accionFinalizada:TRUE];
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    self.tableContainer = nil;

	[listaCelular release];
	[celulares release];
	
	[super dealloc];
}


@end

