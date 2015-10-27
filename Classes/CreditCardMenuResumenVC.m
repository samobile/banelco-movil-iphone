//
//  CreditCardMenuResumenVC.m
//  BanelcoMovilIphone
//
//  Created by Ezequiel Aceto on 29/09/10.
//  Copyright 2010 Mobile Computing. All rights reserved.
//

#import "CreditCardMenuResumenVC.h"
#import "CreditCardResumen.h"
#import "CreditCardResumenVC.h"
#import "CreditCardCell.h"
@implementation CreditCardMenuResumenVC
@synthesize tableView;
@synthesize tarjetas;

#pragma mark -
#pragma mark View lifecycle




- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Tarjetas de Crédito - Último Resumen";	
	qtyTarjetas = 0;
}



-(id) init{
	if (self = [super init]){
		self.tableView.rowHeight = 50;
	}
	
	
	return self;
}



//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { 
//	switch(buttonIndex) {
//		case 0:
//			[[MenuBanelcoController sharedMenuController] peekScreen];
//			break;
//	}
//}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	NSLog(@"accion en CreditCardMenuResumenVC");
	id result;

	result = [CreditCard getVisas:[[Context sharedContext] getToken]];
    
	if ([result isKindOfClass:[NSError class]]) {
		[self accionFinalizada:TRUE]; //??
		
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		//[CommonUIFunctions showAlert:@"Error de cambio de clave" withMessage:errorDesc andCancelButton:@"Volver"];
		[CommonUIFunctions showAlert:@"Consulta Último Resumen" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		return;
        
	}	else if ([result isKindOfClass:[NSMutableArray class]]){
		[self accionFinalizada:TRUE];		
		tarjetas = (NSMutableArray *)result;
		
		if ([tarjetas count] == 0) {
			[CommonUIFunctions showAlert:@"Consulta Último Resumen" withMessage:@"No hay información sobre tus tarjetas de crédito por el momento." cancelButton:@"Volver" andDelegate:self];
			
		}
		else {
			UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 20)];
			l.text = @"Tarjetas VISA";
			if (![Context sharedContext].personalizado) {
                l.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
            }
            else {
                l.font = [UIFont boldSystemFontOfSize:17];
            }
			l.backgroundColor = [UIColor clearColor];
			l.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
			[self.view addSubview:l];
			[l release];
			
			qtyTarjetas = [tarjetas count];
			[self.tableView reloadData];
		}
		
		
	}	else {
		NSLog(@"Error: No se recibio un array de tarjetas");
		[self accionFinalizada:TRUE];
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return (qtyTarjetas == 0?0:1);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return qtyTarjetas;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TarjetasCellIdentifier";
    
    CreditCardCell *cell = (CreditCardCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		CreditCard *aCreditCard = [tarjetas objectAtIndex:indexPath.row];
        cell = [[CreditCardCell alloc] initWithCreditCard:aCreditCard];
		[cell setAccessoryType:UITableViewCellEditingStyleDelete];
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
		
		
		
		
		//if (tarjetas != nil && indexPath.row <= [tarjetas count]) {
		
		//	CreditCard *aCreditCard = [tarjetas objectAtIndex:indexPath.row];
		
		
		
		//	NSMutableString *num = [[NSMutableString alloc] init];
		
		//	for (int i = 0; i < 4; i++) {
		//		[num appendFormat:@"."];
		//	}
		
		//	for (int i = [aCreditCard.numero length]-4; i < [aCreditCard.numero length]; i++) {
		//		[num appendFormat:@"%c",[aCreditCard.numero characterAtIndex:i]];
		//	}
		
		//	[[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@",aCreditCard.nombre,num]];
		//	
		//	[num release];
		
	}else{
		
	}
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (tarjetas != nil && indexPath.row <= [tarjetas count]) {
		
		CreditCard *aCreditCard = [tarjetas objectAtIndex:indexPath.row];
		
		CreditCardResumenVC *vc = [[CreditCardResumenVC alloc] initWithNumeroTarjeta:aCreditCard];
		
		[[MenuBanelcoController sharedMenuController] pushScreen:vc];
		
	}
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
    [super dealloc];
}


@end

