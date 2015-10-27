#import "Util.h"
#import "GDataXMLNode.h"

@interface Cotizacion : NSObject {

  NSString * cotizacion;

  NSString * valorCompra;

  NSString * valorVenta;

  NSString * importe;

  int codigoMoneda;

  NSString * simboloMoneda;

  int unidad;

  NSString * importeConvertido;
	
	NSString *fecha;
	
}

@property (nonatomic, retain) NSString * cotizacion;

@property (nonatomic, retain) NSString * valorCompra;

@property (nonatomic, retain) NSString * valorVenta;

@property (nonatomic, retain) NSString * importe;

@property int codigoMoneda;

@property (nonatomic, retain) NSString * simboloMoneda;

@property int unidad;

@property (nonatomic, retain) NSString * importeConvertido;

@property (nonatomic, retain) NSString * fecha;

+ (Cotizacion *) parseSoapObject:(GDataXMLElement *)obj;

+ (id) getCotizacion:(NSString *)numeroCta codCuenta:(NSString *)codTipoCta codMonedaOrigen:(int)codMonO importe:(NSString *)importeValue codMonedaDest:(int)codMonD;

@end
