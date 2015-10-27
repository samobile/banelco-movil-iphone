//
//  UltimasTransferenciasController.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UltimasTransferenciasController.h"
#import "Transfer.h"
#import "CommonUIFunctions.h"
#import "Ticket.h"
#import "UltimoPagoCell.h"
#import "MovimientoView.h"
#import "TransferenciasResult.h"
#import "MenuBanelcoController.h"

@implementation UltimasTransferenciasController

@synthesize tableView, tickets;


- (void)viewDidLoad {
    [super viewDidLoad];

	tickets = [[NSMutableArray alloc] init];
	self.title = @"Últimas Transferencias";
	
	
}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	NSMutableArray *tickets2 = [Transfer getUltimasTransferencias];
	if (!tickets2 || [tickets2 isKindOfClass:[NSError class]]) {
		[self accionFinalizada:TRUE];
        
        NSString *errorCode = [[(NSError *)tickets2 userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)tickets2 userInfo] valueForKey:@"description"];
		[CommonUIFunctions showAlert:@"Últimas Transferencias" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		return;
	}
	else {
		if ([tickets2 count] == 0) {
			[CommonUIFunctions showAlert:@"Últimas Transferencias" withMessage:@"Al momento no contamos con transferencias disponibles" cancelButton:@"Volver" andDelegate:self];
			[self accionFinalizada:TRUE];
			return;
		}
		
		tickets = tickets2;
		
		[tableView reloadData];
		
		[self accionFinalizada:TRUE];
		
	}
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.tickets? [self.tickets count] : 0;
	
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//	
//	if ([self.tickets count] > 0) {
//		
//		UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 18)] autorelease];
//		headerLabel.backgroundColor = [UIColor lightGrayColor];
//		headerLabel.opaque = NO;
//		headerLabel.textColor = [UIColor whiteColor];
//		headerLabel.highlightedTextColor = [UIColor whiteColor];
//		headerLabel.font = [UIFont boldSystemFontOfSize:17];
//		headerLabel.textAlignment = UITextAlignmentCenter;
//		
//		headerLabel.text = [[self.tickets objectAtIndex:0] empresa];
//		
//		return headerLabel;
//	}
//	return nil;
//}

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
	
	
//	TicketController* tController =  [[TicketController alloc] 
//									  initWithTicket:ticket];
	
	TransferenciasResult *tres = [[TransferenciasResult alloc] initWithTitle:@"Detalle de Transferencia" transfer:nil ticket:ticket];
	[[MenuBanelcoController sharedMenuController] pushScreen:tres];
	
}

- (void)dealloc {
    [super dealloc];
}


@end
