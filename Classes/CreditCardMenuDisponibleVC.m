//
//  CreditCardMenuDisponibleVC.m
//  BanelcoMovilIphone
//
//  Created by Ezequiel Aceto on 29/09/10.
//  Copyright 2010 Mobile Computing. All rights reserved.
//

#import "CreditCardMenuDisponibleVC.h"
#import "CreditCardDisponibleVC.h"
#import "CreditCardCell.h"
#import "WS_ConsultarTarjetas.h"

@implementation CreditCardMenuDisponibleVC

@synthesize tableView;
@synthesize tarjetas;

#pragma mark -
#pragma mark View lifecycle



- (void)viewDidLoad {
    [super viewDidLoad];
	qtyTarjetas = 0;
	self.title = @"Tarjetas de Crédito - Disponible";	
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
	NSLog(@"accion en CreditCardMenuDisponibleVC");
	id result;
	
    id resultTar = nil;
    WS_ConsultarTarjetas *requestTar = [[WS_ConsultarTarjetas alloc] init];
    Context *context = [Context sharedContext];
    requestTar.userToken = [context getToken];
    resultTar = [WSUtil execute:requestTar];
    [requestTar release];
    if ([resultTar isKindOfClass:[NSError class]]) {
        resultTar = nil;
    }
    
	result = [CreditCard getVisas:[[Context sharedContext] getToken]];
	
	if ([result isKindOfClass:[NSError class]]) {
		[self accionFinalizada:FALSE]; //??
		
        NSString *errorCode = [[(NSError *)result userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            return;
        }
        
		NSString *errorDesc = [[(NSError *)result userInfo] valueForKey:@"description"];
		//[CommonUIFunctions showAlert:@"Error de cambio de clave" withMessage:errorDesc andCancelButton:@"Volver"];
		[CommonUIFunctions showAlert:@"Consulta Disponible" withMessage:errorDesc cancelButton:@"Volver" andDelegate:self];
		return;
		
	}	else if ([result isKindOfClass:[NSMutableArray class]]){
		[self accionFinalizada:TRUE];		
		tarjetas = (NSMutableArray *)result;
		
		if ([tarjetas count] == 0) {
			
		}
		else {
            
            //para usar fecha de vencimiento informada por servicio de tarjetasvisa y no por el servicio de datos adicionales
            for (CreditCard *ccard in resultTar) {
                for (int j = 0; j < [tarjetas count]; j++) {
                    CreditCard *ctar = [tarjetas objectAtIndex:j];
                    if ([[[ccard.numero stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString] isEqualToString:[[ctar.numero stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString]]) {
                        ctar.fechaVencimiento = ccard.fechaVencimiento;
                        [tarjetas replaceObjectAtIndex:j withObject:ctar];
                    }
                }
                
            }
            
            
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
		[self accionFinalizada:FALSE];
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
			
		CreditCardDisponibleVC *vc = [[CreditCardDisponibleVC alloc] initWithNumeroTarjeta:aCreditCard];
		
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
	[tarjetas release];
    [super dealloc];
}


@end

