//
//  AyudaController.m
//  BanelcoMovilIphone
//
//  Created by Demian on 9/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AyudaController.h"
#import "AyudaPaginadaController.h"
#import "BanelcoMovilIphoneViewController.h"
#import "BanelcoMovilIphoneViewControllerGenerico.h"
#import "Configuration.h"
#import "Context.h"
#import "CommonFunctions.h"

@implementation AyudaController

@synthesize listaDeAyuda, opcionesDeAyuda, apc, lblTitulo, fullScreen, listaDeAyudaContenedor, fndImage , acvc;

//int indicesAyuda[7] = {0, 1, 5, 2, 6, 3, 4}; // Mapeo de indices


-(id) init{
	if (self = [super init]){
		
		NSString *str;
		if ([[Context sharedContext] personalizado]) {
			str = [NSString stringWithFormat:@"¿Qué es %@?",[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Personalizacion"] objectForKey:@"AppName"]];
		}
		else {
			str = [NSString stringWithFormat:@"¿Qué es %@?",@"Banelco MÓVIL"];//[NSString stringWithFormat:@"¿Qué es %@?",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
		}

		opcionesDeAyuda = [[NSMutableArray alloc] initWithObjects:str, @"¿Cómo operar?",@"¿Cómo generar la clave?",@"Servicios",@"Cambio de Clave",@"Seguridad",@"Costo del Servicio",@"Contacto", nil];
		apc = [[AyudaPaginadaController alloc] initWithOptionNumber:-1];
		apc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		self.fullScreen = NO;
		
	}
	return self;
}


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	
	if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
		NSString *str;
		if ([[Context sharedContext] personalizado]) {
			str = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Personalizacion"] objectForKey:@"AppName"];
		}
		else {
			str = @"Banelco MÓVIL";//[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
		}
		
		opcionesDeAyuda = [[NSMutableArray alloc] initWithObjects:
						    [NSString stringWithFormat:@"¿Qué es %@?",str], @"¿Cómo operar?",@"¿Cómo generar la clave?",@"Servicios",@"Cambio de Clave",@"Seguridad",@"Costo del Servicio",@"Contacto", nil];
		apc = [[AyudaPaginadaController alloc] initWithOptionNumber:-1];
		apc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		self.fullScreen = YES;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![Context sharedContext].personalizado) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
	
	/*NSString *env = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Environment"];

	if (![env isEqualToString:@"PROD"]) {
		lblTitulo.text = [NSString stringWithFormat:@"%@ %@", 
						  lblTitulo.text, 
						  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
	}*/
	
	lblTitulo.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    if (![Context sharedContext].personalizado) {
        lblTitulo.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
    
    //listaDeAyudaContenedor.frame = CGRectMake(listaDeAyudaContenedor.frame.origin.x, listaDeAyudaContenedor.frame.origin.x, listaDeAyudaContenedor.frame.size.width, 44 * [self.opcionesDeAyuda count]);
    CGRect r = self.fndImage.frame;
    r.size.height = IPHONE5_HDIFF(self.fndImage.frame.size.height);
    self.fndImage.frame = r;
    
//    CGRect rv = self.view.frame;
//    rv.size.height = IPHONE5_HDIFF(self.view.frame.size.height);
//    self.view.frame = rv;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (IS_IPHONE_5) {
        listaDeAyuda.scrollEnabled = YES;
        //[listaDeAyuda becomeFirstResponder];
        CGRect r = listaDeAyudaContenedor.frame;
        //listaDeAyudaContenedor.frame = CGRectMake(r.origin.x, lblTitulo.frame.origin.y + lblTitulo.frame.size.height, r.size.width, (r.origin.y + r.size.height) > self.view.frame.size.height ? r.origin.y + r.size.height - self.view.frame.size.height - 5: self.view.frame.size.height - (r.origin.y + r.size.height) - 5);
        CGFloat dif = r.origin.y + r.size.height - self.view.frame.size.height;
        if (dif < 0) {
            dif = 0;
        }
        listaDeAyudaContenedor.frame = CGRectMake(r.origin.x, lblTitulo.frame.origin.y + lblTitulo.frame.size.height, r.size.width, r.size.height + 70);
        listaDeAyuda.frame = listaDeAyudaContenedor.bounds;
        //listaDeAyuda.frame = CGRectMake(0, 0, listaDeAyudaContenedor.frame.size.width, listaDeAyudaContenedor.frame.size.height + 50);
    }
    else {
        CGRect r = listaDeAyudaContenedor.frame;
        //listaDeAyudaContenedor.frame = CGRectMake(r.origin.x, lblTitulo.frame.origin.y + lblTitulo.frame.size.height, r.size.width, (r.origin.y + r.size.height) > self.view.frame.size.height ? r.size.height - (self.view.frame.size.height - (r.origin.y + r.size.height)) - 5: r.size.height - 5);
        CGFloat dif = r.origin.y + r.size.height - self.view.frame.size.height;
        if (dif < 0) {
            dif = 0;
        }
        listaDeAyudaContenedor.frame = CGRectMake(r.origin.x, lblTitulo.frame.origin.y + lblTitulo.frame.size.height, r.size.width, r.size.height - dif - 5);
        listaDeAyuda.frame = CGRectMake(0, 0, listaDeAyudaContenedor.frame.size.width, listaDeAyudaContenedor.frame.size.height);
    }
}


-(IBAction) volver{
	
	[self dismissModalViewControllerAnimated:YES];
}
//--------
//--------


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self opcionesDeAyuda] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    
    if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault//UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"MyCell"];
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.backgroundColor = [UIColor clearColor];
        [cell autorelease];
    }
	NSUInteger index = [indexPath row];
    NSString *text = [[self opcionesDeAyuda] objectAtIndex:index];
	[[cell textLabel] setText:text];
	//personalizacion
	cell.textLabel.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    if (![Context sharedContext].personalizado) {
        cell.textLabel.font = [UIFont fontWithName:@"BanelcoBeau-Bold" size:17];
    }
   
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSLog(@"Row seleccionado = %d",indexPath.row);
	//[apc release];
	if(indexPath.row<7)
    {
    if (fullScreen) {
		//apc =  [[AyudaPaginadaController alloc] initWithNibName:@"AyudaPaginadaFullScreen" bundle:nil andNumber:indicesAyuda[indexPath.row]]; // Mapeo de indices
		apc =  [[AyudaPaginadaController alloc] initWithNibName:@"AyudaPaginadaFullScreen" bundle:nil andNumber:indexPath.row];

		[self presentModalViewController:apc animated:YES];
		[apc iniciarAccionConCorrimientoEnY:0];
	}else {
		//apc = [[AyudaPaginadaController alloc] initWithOptionNumber:indicesAyuda[indexPath.row]]; // Mapeo de indices
		apc = [[AyudaPaginadaController alloc] initWithOptionNumber:indexPath.row];
		
        [[BanelcoMovilIphoneViewController sharedMenuController] pushScreen:apc];
		[apc inicializar];
	}
    }
    else
    {
        if (fullScreen) {
            
            acvc =  [[AyudaContactoViewController alloc] initWithNibName:@"ayudaContactoFullScreen" bundle:nil];
            
            [self presentModalViewController:acvc animated:YES];
           
        }else {
            
            acvc = [[AyudaContactoViewController alloc] init];
            
            [[BanelcoMovilIphoneViewController sharedMenuController] pushScreen:acvc];
           
        }
    }

	
	
	
//	apc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	
	//[apc refreshWithNumber:indexPath.row];
	//[self.view addSubview:apc.view];

	
	//[apc inicializar];	
	
}


//--------------
//--------------



- (void)dealloc {
	[apc release];
	[listaDeAyuda release];
	[opcionesDeAyuda release];
    self.listaDeAyudaContenedor = nil;
    self.fndImage = nil;
    [super dealloc];
}


@end
