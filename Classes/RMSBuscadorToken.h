

@interface RMSBuscadorToken : NSObject {

	NSString * codigoBanco;
	
	NSString * dni;
	
}

@property (nonatomic, retain) NSString * codigoBanco;

@property (nonatomic, retain) NSString * dni;

- (BOOL) matches:(NSString *)registro;
- (id) init:(NSString *)codigoBanco dni:(NSString *)dni;

@end
