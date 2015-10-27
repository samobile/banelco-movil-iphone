//
//  TasasPlazoFijoResult.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomDetail.h"
#import "Cuenta.h"

@interface TasasPlazoFijoResult : CustomDetail {
	
	Cuenta *ctaPlazo;
	NSString *importe;
	NSString *plazo;
	
	IBOutlet UILabel *seuo;
	IBOutlet UILabel *fecha;
	IBOutlet UILabel *hora;
}

@property (nonatomic, retain) Cuenta *ctaPlazo;
@property (nonatomic, retain) NSString *importe;
@property (nonatomic, retain) NSString *plazo;
@property (nonatomic, retain) IBOutlet UILabel *seuo;
@property (nonatomic, retain) IBOutlet UILabel *fecha;
@property (nonatomic, retain) IBOutlet UILabel *hora;

- (id) initWithTitle:(NSString *)t ctaPlazo:(Cuenta *)cPlazo importe:(NSString *)ite plazo:(NSString *)p;

@end
