//
//  TyCPaginadoController.m
//  BanelcoMovilIphone
//
//  Created by Demian on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TyCPaginadoController.h"
#import "Context.h"
#import "Util.h"
#import "CommonUIFunctions.h"
#import "MenuBanelcoController.h"
#import "BanelcoMovilIphoneViewController.h"
#import "BanelcoMovilIphoneViewControllerGenerico.h"
#import "Configuration.h"

@implementation TyCPaginadoController

@synthesize scrollView;
@synthesize pageControl;
@synthesize receivedData;
@synthesize theConnection;
@synthesize cantidadDePaginas;
@synthesize actualPaginaRequest;
@synthesize textoDePaginas, fndImage;


- (void)viewDidLoad 
{
	//	[self setupPage];
	[super viewDidLoad];
    
    if (![Context sharedContext].personalizado) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
	
    viewLoaded = NO;
	// Create the request.
	
	textoDePaginas = [[NSMutableArray alloc] init];
	cantidadDePaginas = 0;
	actualPaginaRequest = 1;
	//[self accionConBloqueo];
//	[self pedirPaginaNumero:actualPaginaRequest];
//	[self encenderRueda];
    
//    CGRect r = self.pageControl.frame;
//    self.pageControl.frame = CGRectMake(r.origin.x, r.origin.y + (IS_IPHONE_5 ? 50 : 0), r.size.width, r.size.height);
//    
//    r = self.scrollView.frame;
//    self.scrollView.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height + (IS_IPHONE_5 ? 50 : 0));
    
    CGRect r = self.fndImage.frame;
    r.size.height = IPHONE5_HDIFF(self.fndImage.frame.size.height);
    self.fndImage.frame = r;
	
}
-(void) accion{
	//	return [self pedirPaginaNumero:actualPaginaRequest];
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
		[CommonUIFunctions showAlert:@"Ayuda" withMessage:@"En este momento no se puede realizar la operación. Reintenta más tarde." cancelButton:@"Aceptar" andDelegate:self];
		return;
	}
	NSArray *a = [respuesta componentsSeparatedByString:@"|"];
    if ([a count] < 2) {
        [CommonUIFunctions showAlert:@"Ayuda" withMessage:@"En este momento no se puede realizar la operación. Reintenta más tarde." cancelButton:@"Aceptar" andDelegate:self];
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

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	
    [[BanelcoMovilIphoneViewController sharedMenuController] inicioAccion];
}

- (NSString *)procesarRequestHTTP:(NSString *)urlString {
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url] ;
	
	NSURLResponse *response = [[NSURLResponse alloc] init];
	NSError *error = [[NSError alloc] init];
	NSData *data = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error]; 
	
	return [[NSString alloc] initWithBytes: [data mutableBytes] length:[data length] encoding:NSUTF8StringEncoding];
	
}


-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (viewLoaded) {
        viewLoaded = YES;
        CGRect r = self.pageControl.frame;
        self.pageControl.frame = CGRectMake(r.origin.x, r.origin.y + (IS_IPHONE_5 ? 50 : 0), r.size.width, r.size.height);
        
        r = self.scrollView.frame;
        self.scrollView.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height + (IS_IPHONE_5 ? 50 : 0));
    }
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
	
    [super dealloc];
}

#pragma mark -
#pragma mark The Guts
- (void)setupPage
{
	
	scrollView.delegate = self;
	[self.scrollView setBackgroundColor:nil];
	[scrollView setCanCancelContentTouches:NO];
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	CGFloat cx = 0;
	
	
	for (int i=0; i<cantidadDePaginas; i++) {
		
		UITextView *textView = [[UITextView alloc] init];
		textView.editable = NO;
		textView.backgroundColor = [UIColor clearColor];
		CGRect rect = textView.frame;
		rect.size.height = 300;
		rect.size.width = 290;
		rect.origin.x = ((scrollView.frame.size.width - 290) / 2) + cx;
		rect.origin.y = ((scrollView.frame.size.height - 300) / 2);
		
		textView.frame = rect;
		
		textView.text = (NSString*)[textoDePaginas objectAtIndex:i];
		textView.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
        if (![Context sharedContext].personalizado) {
            textView.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        }
		[scrollView addSubview:textView];
		[textView release];
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
