//
//  CargaCelularMenu.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"

@class BanelcoMovilIphoneViewController, WaitingAlert;

@interface UsuarioMenuController : StackableScreen <UIAlertViewDelegate> {

    BanelcoMovilIphoneViewController* contr;
    
    IBOutlet UIButton *btnVolver;
    IBOutlet UIButton *btnUsuario;
    IBOutlet UILabel *titDatos;
    
    WaitingAlert *alert;
    IBOutlet UIImageView *fndImage;
    
}

@property (nonatomic, retain) UIImageView *fndImage;

@property (nonatomic, assign) BanelcoMovilIphoneViewController* contr;

@property (nonatomic, retain) UIButton *btnVolver;
@property (nonatomic, retain) UIButton *btnUsuario;
@property (nonatomic, retain) UILabel *titDatos;

-(id) initWithController:(BanelcoMovilIphoneViewController*)control CargaDatos:(BOOL)cargaDatos;

@end
