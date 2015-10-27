#import <UIKit/UIKit.h>
#import "Cuenta.h"

@interface CuentaCell : UITableViewCell {

	UIImageView* fondo;
	
	UILabel* cuentaDescripcion;
	
	UILabel* cuentaSaldo;
	
	UILabel* cuentaNumero;
}

@property(nonatomic,retain) UIImageView* fondo;
@property(nonatomic,retain) UILabel* cuentaDescripcion;
@property(nonatomic,retain) UILabel* cuentaSaldo;
@property(nonatomic,retain) UILabel* cuentaNumero;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier andCuenta:(Cuenta*) cuenta conSaldo:(BOOL) conSaldo;

- (id)initSmallWithReuseIdentifier:(NSString *)reuseIdentifier andCuenta:(Cuenta*)cuenta inWidth:(CGFloat)width;

-(void) cargarDescripcion:(NSString*) texto;

-(void) cargarDescripcionCorta:(NSString*) texto;

-(void) cargarSaldo:(NSString*) texto;

-(void) cargarNumero:(NSString*) texto;
	

@end
