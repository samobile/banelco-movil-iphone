//
//  AceptarTerminosController.h
//  BanelcoMovilIphone
//
//  Created by Demian on 9/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AceptarTerminosController : UIViewController {

	BOOL terminosAceptados;
	
	IBOutlet UIButton* aceptarTerminosBoton;
	IBOutlet UIButton* continuarBoton;
	
	
	IBOutlet UIActivityIndicatorView* activityConexion;
	
	IBOutlet UILabel *ltyc;
    
    IBOutlet UIImageView *fndApp;
    
    id contr;
    
    CGFloat yInicial;
}

@property (nonatomic, assign) id contr;

-(IBAction) verTerminos;
-(IBAction) aceptarTerminos;
-(IBAction) continuar;

@property (nonatomic, retain) UIImageView *fndApp;

@property BOOL terminosAceptados;

@property(nonatomic,retain) UIButton* aceptarTerminosBoton;
@property(nonatomic,retain) UIButton* continuarBoton;
@property(nonatomic,retain) UIActivityIndicatorView* activityConexion;

@property (nonatomic, retain) IBOutlet UILabel *ltyc;

@end
