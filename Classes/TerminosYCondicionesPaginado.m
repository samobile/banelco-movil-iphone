#import "TerminosYCondicionesPaginado.h"
#import "Context.h"
#import "Util.h"
#import "CommonUIFunctions.h"

@implementation TerminosYCondicionesPaginado

@synthesize scrollView;
@synthesize pageControl;
@synthesize receivedData;
@synthesize theConnection;
@synthesize cantidadDePaginas;
@synthesize actualPaginaRequest;
@synthesize textoDePaginas;
@synthesize ltyc, fndApp;

#pragma mark -
#pragma mark UIView boilerplate
- (void)viewDidLoad 
{
	[super viewDidLoad];
    
    if (![Context sharedContext].personalizado) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
	textoDePaginas = [[NSMutableArray alloc] init];
	cantidadDePaginas = 0;
	actualPaginaRequest = 1;
	
	ltyc.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    
    CGRect r = self.fndApp.frame;
    r.size.height = IPHONE5_HDIFF(r.size.height);
    self.fndApp.frame = r;
    r = self.scrollView.frame;
    r.size.height = IPHONE5_HDIFF(r.size.height);
    self.scrollView.frame = r;
    r = self.pageControl.frame;
    r.origin.y = IPHONE5_HDIFF(r.origin.y);
    self.pageControl.frame = r;

}
-(void) accion{
	//	return [self pedirPaginaNumero:actualPaginaRequest];
}

-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self iniciarAccionConCorrimientoEnY:120];
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
	
	//[self setupPage];
	// Si no se ejecuta en el hilo principal la aplicacion rompe al intentar instanciar el UITextView
	[self performSelectorOnMainThread:@selector(setupPage) withObject:nil waitUntilDone:YES];
	
	[delegate accionFinalizada:TRUE];
	
}




- (void) pedirPaginaNumero:(int) numeroDePagina {
	
	NSString *env = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Environment"];
	NSString *urlAyuda = [NSString stringWithFormat:@"%@?codigo_banco=%@&index=7&pagina=%d", 
						  [[NSBundle mainBundle] objectForInfoDictionaryKey:[NSString stringWithFormat:@"urlAyuda_%@",env]], 
						  [Context sharedContext].banco.idBanco, numeroDePagina];
	NSLog(@"url ===== %@" , urlAyuda);
	NSMutableString* respuesta = [self procesarRequestHTTP:urlAyuda];
	
	//controla que la respuesta no sea vacia
	if (!respuesta || [respuesta length] == 0) {
		[CommonUIFunctions showAlert:@"Términos y Condiciones" withMessage:@"En este momento no se puede realizar la operación. Reintenta más tarde." cancelButton:@"Aceptar" andDelegate:self];
		return;
	}
	NSArray *a = [respuesta componentsSeparatedByString:@"|"];
    if ([a count] < 2) {
        [CommonUIFunctions showAlert:@"Términos y Condiciones" withMessage:@"En este momento no se puede realizar la operación. Reintenta más tarde." cancelButton:@"Aceptar" andDelegate:self];
		return;
    }
    
    
	[textoDePaginas addObject:[Util decode:[[respuesta componentsSeparatedByString:@"|"] objectAtIndex:2]]];
	
	if (cantidadDePaginas ==0){
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




-(int) calcularCantidadDePaginas:(NSString*) datos{
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
	
	
	return 10;
	//	[[datos substringWithRange:rangoNumero] intValue];
	
	
}
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
	//[scrollView release];
	//[pageControl release];
}
-(IBAction) back{
	
	[self dismissModalViewControllerAnimated:YES];
} 

- (void)dealloc 
{
    //self.fndApp = nil;
	//[ltyc release];
    [super dealloc];
}

#pragma mark -
#pragma mark The Guts
- (void)setupPage
{
	
	scrollView.delegate = self;
	[self.scrollView setBackgroundColor:[UIColor clearColor]];
	[scrollView setCanCancelContentTouches:NO];
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	CGFloat cx = 0;
	
//    for (int i=0; i<cantidadDePaginas; i++) {
//        
//        UITextView* tView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 290, 300)];
//        tView.editable = NO;
//        tView.backgroundColor = [UIColor clearColor];
//        CGRect rect = tView.frame;
//        rect.size.height = 300;
//        rect.size.width = 290;
//        rect.origin.x = ((scrollView.frame.size.width - 290) / 2) + cx;
//        rect.origin.y = ((scrollView.frame.size.height - 300) / 2);
//        
//        tView.frame = rect;
//        
//        
//        tView.text = (NSString*)[textoDePaginas objectAtIndex:i];
//        tView.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
//        if (![Context sharedContext].personalizado) {
//            tView.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
//        }
//        [scrollView addSubview:tView];
//        [tView release];
//        cx += scrollView.frame.size.width;
//        
//    }
	for (int i=0; i<cantidadDePaginas; i++) {
		
		UITextView* tView = [[UITextView alloc] initWithFrame:self.scrollView.bounds];
		tView.editable = NO;
		tView.backgroundColor = [UIColor clearColor];
		CGRect rect = tView.frame;
		//rect.size.height = 300;
		//rect.size.width = 290;
		rect.origin.x = cx;
		//rect.origin.y = ((scrollView.frame.size.height - 300) / 2);
		
		tView.frame = rect;
		
		
		tView.text = (NSString*)[textoDePaginas objectAtIndex:i];
		tView.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
        if (![Context sharedContext].personalizado) {
            tView.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        }
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
	NSLog(@"hh1");
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark PageControl stuff
- (IBAction)changePage:(id)sender 
{
	/*
	 *	Change the scroll view
	 */
	NSLog(@"cp1");
    CGRect frame = scrollView.frame;
	NSLog(@"cp2");
    frame.origin.x = frame.size.width * pageControl.currentPage;
	NSLog(@"cp3");
    frame.origin.y = 0;
	NSLog(@"cp4");
    [scrollView scrollRectToVisible:frame animated:YES];
	NSLog(@"cp5");
	/*
	 *	When the animated scrolling finishings, scrollViewDidEndDecelerating will turn this off
	 */
	NSLog(@"cp6");
    pageControlIsChangingPage = YES;
	NSLog(@"cp7");
}




@end
