//
//  TransferenciasRef.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 24/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"
#import "Transfer.h"
#import "BaseModel.h"

@interface TransferenciasRef : StackableScreen <UITextFieldDelegate> {
	IBOutlet UITextField *refText;
	IBOutlet UIButton *botonContinuar;
	
	Transfer *transfer;
	UIImageView* barTeclado;
	UIButton* barTecladoButton;
	
	IBOutlet UILabel *lRef;
}
@property(nonatomic,retain) UIButton* barTecladoButton;
@property(nonatomic,retain) UIImageView* barTeclado;


@property (nonatomic, retain) IBOutlet UITextField *refText;
@property (nonatomic, retain) IBOutlet UIButton *botonContinuar;

@property (nonatomic, retain) Transfer *transfer;

@property (nonatomic, retain) IBOutlet UILabel *lRef;

- (IBAction) continuar;
- (void)screenDidAppear;

@end
