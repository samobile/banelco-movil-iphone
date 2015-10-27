//
//  UltimosPagosController.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UltimosPagosController.h"
#import "Ticket.h"
#import "UltimoPagoCell.h"
#import "CommonUIFunctions.h"
#import "MenuBanelcoController.h"
#import "UltimoPagoCell.h"
#import "DetalleDeudaController.h"
#import "TicketController.h"

@implementation UltimosPagosController

@synthesize empresa, tickets, tableView;


- (id)initWithEmpresa:(Empresa *)empresa {
    if ((self = [super init])) {
		self.title = @"Mis Comprobantes";
        self.empresa = empresa;
		self.tickets = [[NSMutableArray alloc] init];
    }
    return self;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (void)accionWithDelegate:(WheelAnimationController *)delegate {

	NSMutableArray *arraySinOrdenar = [self.empresa getUltimosPagos:0];
	
	if (![arraySinOrdenar isKindOfClass:[NSError class]]) {
		
		self.tickets = [NSMutableArray arrayWithArray:[arraySinOrdenar sortedArrayUsingSelector:@selector(compare:)]];
		
		if ([self.tickets count] > 0) {

			[tableView reloadData];

		} else {
			[CommonUIFunctions showAlert:@"Últimos Comprobantes" 
							 withMessage:@"No presentas comprobantes de esta empresa" 
							cancelButton:@"Volver" andDelegate:self];
			
			//[[MenuBanelcoController sharedMenuController] volver];
		}
		
	} else {
		
		NSString *errorDesc = [[(NSError *)arraySinOrdenar userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:@"Últimos Comprobantes" withMessage:errorDesc 
						cancelButton:@"Volver" andDelegate:self];
		
	}
	
	[delegate accionFinalizada:TRUE];
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.tickets? [self.tickets count] : 0;
	
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	
//	if ([self.tickets count] > 0) {
//		return [[self.tickets objectAtIndex:0] empresa];
//	}
//
//	return nil;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

	if ([self.tickets count] > 0) {
	
		UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 18)] autorelease];
		headerLabel.backgroundColor = [UIColor lightGrayColor];
		headerLabel.opaque = NO;
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.highlightedTextColor = [UIColor whiteColor];
		headerLabel.font = [UIFont boldSystemFontOfSize:17];
		headerLabel.textAlignment = UITextAlignmentCenter;
		
		headerLabel.text = [[self.tickets objectAtIndex:0] empresa];
	
		return headerLabel;
	}
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    Ticket *ticket = [self.tickets objectAtIndex:indexPath.row];
	
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UltimoPagoCell alloc] initWithReuseIdentifier:CellIdentifier andTicket:ticket] autorelease];
		cell = [[[UltimoPagoCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellEditingStyleDelete];
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.backgroundColor = [UIColor clearColor];
    }
	
	[(UltimoPagoCell *)cell inicializar:ticket];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Ticket *ticket = [self.tickets objectAtIndex:indexPath.row];
		
	//DEM TODO
	
//	DetalleDeudaController *detalle = [[DetalleDeudaController alloc] 
//									   initWithTicket:ticket];
//	[[MenuBanelcoController sharedMenuController] pushScreen:detalle];
	
	
	TicketController* tController = nil;
	
	if ([[self.empresa.codigo uppercaseString] isEqualToString:@"SUBE"]) {
		tController = [[TicketController alloc] initSubeWithTicket:ticket];
	} else {
		tController = [[TicketController alloc] initWithTicket:ticket];
	}

	[[MenuBanelcoController sharedMenuController] pushScreen:tController];

}



- (void)showTicketsPagos {

	CGFloat y = 0;
	
	for (Ticket *t in tickets) {
		
		UIView *view = [[self buildTicketItem:t] view];
		//view.frame.origin = CGPointMake(view.frame.origin.x, y);
		view.frame = CGRectMake(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height);
		//[self addContentView:view];
		[self.view addSubview:view];
		
		[view release];
		y += view.frame.size.height;
		
	}
	
}

- (UIViewController *)buildTicketItem:(Ticket *)ticket {
	
	NSString *valor = [NSString stringWithFormat:@"%@ %@", ticket.moneda, ticket.importe];
	
	return [[UltimoPagoCell alloc] initWithFecha:ticket.fechaPago yValor:valor];

}

- (void)executeShowAlert:(id)object {

	[CommonUIFunctions showAlert:@"Últimos Comprobantes" withMessage:object andCancelButton:@"Volver"];

}


- (void)dealloc {
	//[empresa release];
	[tickets release];
    [super dealloc];
}


@end
