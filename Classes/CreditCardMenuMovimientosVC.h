//
//  CreditCardMenuMovimientosVC.h
//  BanelcoMovilIphone
//
//  Created by Ezequiel Aceto on 29/09/10.
//  Copyright 2010 Mobile Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import "WS_ConsultarTarjetasVisa.h"
#import "Context.h"
#import "WSUtil.h"
#import "CommonUIFunctions.h"

#import "MenuBanelcoController.h"

@interface CreditCardMenuMovimientosVC : WheelAnimationController <UITableViewDelegate>{
	
	IBOutlet UITableView *tableView;
	
	int qtyAccounts;
	
	int qtyTarjetas;
	
	NSMutableArray *tarjetas;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *tarjetas;

@end
