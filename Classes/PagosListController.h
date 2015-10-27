//
//  PagosListController.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"


@interface PagosListController : WheelAnimationController <UITableViewDelegate> {

	NSMutableArray *deudas;
	
	IBOutlet UITableView *tableView;
	
	IBOutlet UILabel *lb_sindeudas;
	
	IBOutlet UIButton *btnOtras;
	
	int operacion;
	
	BOOL conOtrasOperaciones;
    
    BOOL nuevaTarjeta;
	
    IBOutlet UIButton *btnNuevoPago;
}

@property (nonatomic, retain) NSMutableArray *deudas;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) IBOutlet UILabel *lb_sindeudas;

@property (nonatomic, retain) IBOutlet UIButton *btnOtras;

@property (nonatomic, retain) UIButton *btnNuevoPago;

extern int const PL_DEUDAS_ADHERIDAS;
extern int const PL_OTROS_PAGOS;


- (id)initWithDeudas:(NSMutableArray *)_deudas;
- (id)initWithDeudasTarjeta:(NSMutableArray *)_deudas;

- (IBAction)otrasOperaciones;

@end
