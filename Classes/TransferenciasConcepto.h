//
//  TransferenciasConcepto.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 26/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"
#import "Transfer.h"

@interface TransferenciasConcepto : WheelAnimationController <UIPickerViewDelegate, UIPickerViewDataSource> {
	IBOutlet UIPickerView *concepto;
	IBOutlet UIButton *botonContinuar;
	
	NSMutableArray *listaConcepto;
	Transfer *transfer;
	
	BOOL ejecutarConsultaTitularidad;
	
	IBOutlet UILabel *lConcepto;
}

@property (nonatomic,retain) IBOutlet UIPickerView *concepto;
@property (nonatomic, retain) IBOutlet UIButton *botonContinuar;

@property (nonatomic, retain) NSMutableArray *listaConcepto;
@property (nonatomic, retain) Transfer *transfer;

@property BOOL ejecutarConsultaTitularidad;

@property (nonatomic, retain) IBOutlet UILabel *lConcepto;

- (IBAction)continuar;

@end
