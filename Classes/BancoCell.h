#import <Foundation/Foundation.h>


@interface BancoCell : UITableViewCell {
	
	UILabel *nombreBancoLabel;
	UIImageView *iconoBanco;
	
}
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier nombreBanco:(NSString*) nombre andImageName:(NSString*)nombreImagen;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier andNombreBanco:(NSString*) nombre;
-(void) cargarImagen:(NSString*) nombreImagen;
-(void) cargarLabel:(NSString*) nombre;
	

@property(nonatomic,retain) UILabel *nombreBancoLabel;
@property(nonatomic,retain) UIImageView *iconoBanco;


@end