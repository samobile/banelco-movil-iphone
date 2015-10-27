//
//  DisponibleExtraccion.h
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 7/13/15.
//
//

#import <UIKit/UIKit.h>
#import "WheelAnimationController.h"

@class Cuenta;

@interface DisponibleExtraccion : WheelAnimationController {
    IBOutlet UILabel* descripcion;
    IBOutlet UILabel *importe;
    Cuenta *cuenta;
}

@property (nonatomic, retain) UILabel* descripcion;
@property (nonatomic, retain) UILabel* importe;
@property (nonatomic, retain) Cuenta *cuenta;

-(id) initWithCuenta:(Cuenta*) c;

@end
