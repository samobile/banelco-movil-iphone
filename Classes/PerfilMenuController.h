//
//  CargaCelularMenu.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackableScreen.h"

@class BanelcoMovilIphoneViewController;

@interface PerfilMenuController : StackableScreen {

    BanelcoMovilIphoneViewController* contr;
    
    IBOutlet UILabel *usuario;
    IBOutlet UILabel *nombre;
    IBOutlet UILabel *venc;
    IBOutlet UILabel *ultAcc;
    IBOutlet UILabel *titDatos;
    
    IBOutlet UIButton *btnCambioClave;
    IBOutlet UIButton *btnUsuario;
    
    IBOutlet UIImageView *fndImage;
    
}

@property (nonatomic, retain) UIImageView *fndImage;
@property (nonatomic, assign) BanelcoMovilIphoneViewController* contr;

@property (nonatomic, retain) UILabel *usuario;
@property (nonatomic, retain) UILabel *nombre;
@property (nonatomic, retain) UILabel *venc;
@property (nonatomic, retain) UILabel *ultAcc;
@property (nonatomic, retain) UILabel *titDatos;

@property (nonatomic, retain) UIButton *btnCambioClave;
@property (nonatomic, retain) UIButton *btnUsuario;

-(id) initWithController:(BanelcoMovilIphoneViewController*)control CargaDatos:(BOOL)cargaDatos;

@end
