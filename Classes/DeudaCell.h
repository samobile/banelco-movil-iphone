#import <UIKit/UIKit.h>
#import "Deuda.h"

@interface DeudaCell : UITableViewCell {

	UIImageView* fondo;
	
	UILabel* cuentaDescripcion;
	
	UILabel* cuentaSaldo;
	
	UILabel* cuentaNumero;
}

@property(nonatomic,retain) UIImageView* fondo;
@property(nonatomic,retain) UILabel* cuentaDescripcion;
@property(nonatomic,retain) UILabel* cuentaSaldo;
@property(nonatomic,retain) UILabel* cuentaNumero;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier andDeuda:(Deuda *)deuda;

- (void)cargarDeuda:(Deuda *)deuda;

- (void) cargarDescripcion:(Deuda *)deuda;

- (void) cargarImporte:(Deuda *)deuda;

- (void) cargarVto:(Deuda *)deuda;
	

@end
