#import "AyudaPaginadaController.h"
#import "Context.h"
#import "Util.h"
#import "CommonUIFunctions.h"
#import "BanelcoMovilIphoneViewController.h"
#import "BanelcoMovilIphoneViewControllerGenerico.h"
#import "Configuration.h"
#import "CommonFunctions.h"

@implementation AyudaPaginadaController

@synthesize scrollView;
@synthesize pageControl;
@synthesize receivedData;
@synthesize theConnection;
@synthesize cantidadDePaginas;
@synthesize actualPaginaRequest;
@synthesize textoDePaginas;
@synthesize indiceDePregunta, fndApp;

-(id) initWithOptionNumber:(int) numero{
	
	if (self = [super init]){
		self.indiceDePregunta = numero;
		self.nav_volver = YES;
	}
	return self;
	
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andNumber:(int)numero{
	
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
		self.indiceDePregunta = numero;
		self.nav_volver = NO;
	}
	return self;
	
}
-(IBAction) volver{
	
	[self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
	textoDePaginas = [[NSMutableArray alloc] init];
	cantidadDePaginas = 0;
	actualPaginaRequest = 1;
//	[self pedirPaginaNumero:actualPaginaRequest];
    
    self.fndApp.frame = CGRectMake(self.fndApp.frame.origin.x, self.fndApp.frame.origin.y, self.fndApp.frame.size.width, IPHONE5_HDIFF(self.fndApp.frame.size.height + 128));
	
    CGRect r = self.scrollView.frame;
    r.size.height = IPHONE5_HDIFF(r.size.height);
    self.scrollView.frame = r;
}


- (void)accionWithDelegate:(WheelAnimationController *)delegate {
	
	if (cantidadDePaginas!=0){
		[delegate accionFinalizada:TRUE];
		return;
	}
	
	[self pedirPaginaNumero:1]; 
	
	//for (int i = 2 ; i!=cantidadDePaginas;i++ ){
	//	[self pedirPaginaNumero:i]; 
	//}
	[self performSelectorOnMainThread:@selector(setupPage) withObject:nil waitUntilDone:YES];
	[delegate accionFinalizada:TRUE];
	
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	if (!self.nav_volver) {
		[self volver];
	}
	else {
        [[BanelcoMovilIphoneViewController sharedMenuController] peekScreen];
	}

	
}

- (void) pedirPaginaNumero:(int) numeroDePagina{
	NSLog(@"Ayuda pedirPaginaNumero numero %d",indiceDePregunta);
	if (indiceDePregunta < 0) {
		return;
	}
	
	NSString *env = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Environment"];

	NSString *urlAyuda = [NSString stringWithFormat:@"%@?codigo_banco=%@&index=%d&pagina=%d", 
						  [[NSBundle mainBundle] objectForInfoDictionaryKey:[NSString stringWithFormat:@"urlAyuda_%@",env]], 
						  [Context sharedContext].banco.idBanco, self.indiceDePregunta, numeroDePagina];
	
	NSLog(urlAyuda);
	NSMutableString* respuesta = [self procesarRequestHTTP:urlAyuda];
	
	//controla que la respuesta no sea vacia
	if (!respuesta || [respuesta length] == 0) {
		[CommonUIFunctions showAlert:@"Ayuda" withMessage:@"En este momento no se puede realizar la operación. Reintenta más tarde." cancelButton:@"Aceptar" andDelegate:self];
		return;
	}
	NSArray *a = [respuesta componentsSeparatedByString:@"|"];
    if ([a count] < 2) {
        [CommonUIFunctions showAlert:@"Ayuda" withMessage:@"En este momento no se puede realizar la operación. Reintenta más tarde." cancelButton:@"Aceptar" andDelegate:self];
		return;
    }
	NSString *texto = [Util decode:[[respuesta componentsSeparatedByString:@"|"] objectAtIndex:2]];
	
	// Se agrega la versión de la aplicació en "Que es BanelcoMovil"
	if (self.indiceDePregunta == 0) {
		texto = [texto stringByAppendingFormat:
						@"\n\nVersión %@", 
						[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
	}
	
	[textoDePaginas addObject:texto];
	
	if (cantidadDePaginas == 0) {
		cantidadDePaginas = [self calcularCantidadDePaginas:respuesta];
	}
	
	[respuesta release];
	
	actualPaginaRequest++;
	if (actualPaginaRequest<=cantidadDePaginas){
		[self pedirPaginaNumero:actualPaginaRequest];
	}
	
	
}

- (NSString *)procesarRequestHTTP:(NSString *)urlString {
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url] ;
	
	NSURLResponse *response = [[NSURLResponse alloc] init];
	NSError *error = [[NSError alloc] init];
	NSData *data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error]; 
	
	return [[NSString alloc] initWithBytes: [data mutableBytes] length:[data length] encoding:NSUTF8StringEncoding];
	
}





- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
	NSLog(@"did Recieve response");
	[receivedData setLength:0];
	
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
	
	NSLog(@"did recieve data");
	[receivedData appendData:data];
	NSMutableString* aStr;
	aStr = [[NSMutableString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	if ([textoDePaginas count] >= actualPaginaRequest){
		NSMutableString* muta = [textoDePaginas lastObject];
		[muta appendFormat:aStr];
	}else {

		[textoDePaginas addObject:[Util decode:[[aStr componentsSeparatedByString:@"|"] objectAtIndex:2]]];

	}
	
	
	
	
	if (cantidadDePaginas ==0){
		cantidadDePaginas = [self calcularCantidadDePaginas:aStr];
	}
	
	
	
	
	
}




- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
	
	NSLog(@"Connection did finish loading");
    [theConnection release];
    [receivedData release];
	if(actualPaginaRequest + 1 <= cantidadDePaginas){
		actualPaginaRequest++;
		//	[self accionConBloqueo];
		[self pedirPaginaNumero:actualPaginaRequest];
	}else{
		[self accionFinalizada:FALSE];
		[self setupPage];
		
	}
	
}



-(int) calcularCantidadDePaginas:(NSString*) datos{
	NSLog(@"calcular cantidad de datos");
	NSRange rango;
	NSRange rangoNumero;
	rango.location = 2;
	rango.length = 1;
	rangoNumero.length = 1;
	rangoNumero.location = 2;
	
	while ([@"|" isEqualToString: [datos substringWithRange:rango]]) {
		rango.location = rango.location +1;
		rangoNumero.length = rangoNumero.length +1;
	}
	
	NSLog(@"cantidad de paginas = %d",[[datos substringWithRange:rangoNumero] intValue]);
	return [[datos substringWithRange:rangoNumero] intValue];
	
	
}



#pragma mark -
#pragma mark The Guts
- (void)setupPage
{
	
	NSLog(@"Llego a setear");
	
	scrollView.delegate = self;
	[self.scrollView setBackgroundColor:nil];
	[scrollView setCanCancelContentTouches:NO];
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	CGFloat cx = 0;
	
    CGRect r = self.scrollView.bounds;
	
	for (int i=0; i<cantidadDePaginas; i++) {
		
		UITextView* tView = [[UITextView alloc] init];
		tView.editable = NO;
		tView.backgroundColor = [UIColor clearColor];
		//CGRect rect = tView.frame;
		//rect.size.height = IPHONE5_HDIFF(250);
		//rect.size.width = 280;
		//rect.origin.x =  cx + 10 ;
		//rect.origin.y = 0;
		//((scrollView.frame.size.height - 250) / 2);
        
        r.origin.x += cx;
        
		
		tView.frame = r;
		
		
		tView.text = (NSString*)[textoDePaginas objectAtIndex:i];
		if (![Context sharedContext].personalizado) {
            tView.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        }
		else {
            tView.font = [UIFont systemFontOfSize:17];
        }
        
		//personalizacion
		tView.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
		
		[scrollView addSubview:tView];
		[tView release];
		cx += scrollView.frame.size.width;
		
	}
	self.pageControl.numberOfPages = cantidadDePaginas;
	[scrollView setContentSize:CGSizeMake(cx, [scrollView bounds].size.height)];
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
	
	
    if (pageControlIsChangingPage) {
        return;
    }
	
	/*
	 *	We switch page at 50% across
	 */
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
    pageControlIsChangingPage = NO;
}


-(IBAction) hideHelp{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark PageControl stuff
- (IBAction)changePage:(id)sender 
{
	/*
	 *	Change the scroll view
	 */
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
	/*
	 *	When the animated scrolling finishings, scrollViewDidEndDecelerating will turn this off
	 */
    pageControlIsChangingPage = YES;
}


- (void)dealloc {
    [super dealloc];
}

@end