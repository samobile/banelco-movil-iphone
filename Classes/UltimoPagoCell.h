//
//  UltimoPagoController.h
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"


@interface UltimoPagoCell : UITableViewCell {

	IBOutlet UILabel *lbFecha;
	IBOutlet UILabel *lbValor;
}

@property (nonatomic, retain) IBOutlet UILabel *lbFecha;
@property (nonatomic, retain) IBOutlet UILabel *lbValor;

- (void)inicializar:(Ticket *)ticket;


@end
