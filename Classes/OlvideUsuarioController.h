//
//  GenerarClaveController.h
//  BanelcoMovilIphone
//
//  Created by Demian on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OlvideUsuarioController : UIViewController {
	IBOutlet UITextView *leyenda;
	IBOutlet UIView *fondo;
	IBOutlet UIButton *pagoMisCuentasBoton;
}

@property (nonatomic, retain) IBOutlet UITextView *leyenda;

@property (nonatomic, retain) IBOutlet UIButton *pagoMisCuentasBoton;

-(IBAction) pagoMisCuentas;
-(IBAction) homeBanking;
-(IBAction) volver;

-(IBAction) ayuda;
@end
