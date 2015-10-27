#import "SeleccionBancoController.h"
#import "Banco.h"
#import "BancoCell.h"
#import "LoginController.h"
#import "Context.h"
#import "CommonFunctions.h"


@implementation SeleccionBancoController

@synthesize bancosSeleccionados;
@synthesize bancosNoSeleccionados;
@synthesize opcionesMuestra;
@synthesize listaBancos;
@synthesize otrosBancosTable;
@synthesize adding,seleccionadosIDs;
@synthesize backBoton,bancosTotal, sombra;


- (void)viewDidLoad { 
	NSLog(@"View did load!!");
    [super viewDidLoad];
    
    self.view.frame = [CommonFunctions frame4inchDisplay:self.view.frame];
    NSLog(@"fonts: %@", [UIFont fontNamesForFamilyName:@"BanelcoBeau"]);
	self.backBoton.alpha = 0;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    v.backgroundColor = [UIColor clearColor];
	UILabel* tituloLista = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 30)];
	tituloLista.textAlignment = UITextAlignmentLeft;
	//tituloLista.font = [UIFont systemFontOfSize:17];
    tituloLista.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
	tituloLista.text = @"Seleccioná un Banco";
	//tituloLista.textColor = [UIColor blackColor];//[[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
	[v addSubview:tituloLista];
	[tituloLista setBackgroundColor:[UIColor clearColor]];
	listaBancos.tableHeaderView = v;
    [v release];
	//	[plistpath release];
    CGRect r = listaBancos.frame;
    listaBancos.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, IPHONE5_HDIFF(r.size.height));
    
	
	NSString *plistpath = [[NSBundle mainBundle] pathForResource:@"Bancos4" ofType:@"plist"];
	self.bancosTotal = [[NSMutableArray alloc] initWithContentsOfFile:plistpath];
	self.seleccionadosIDs = nil;
	self.bancosSeleccionados=[[NSMutableArray alloc] init];
	self.opcionesMuestra = [[[NSMutableArray alloc] init] autorelease];
	self.bancosNoSeleccionados = [[NSMutableArray alloc] init];
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathSelectedBanks]]){
		self.seleccionadosIDs = [[NSMutableArray alloc] initWithContentsOfFile:[self pathSelectedBanks]];
		for (int i=0; i<[self.bancosTotal count]; i++) {
			if ([SeleccionBancoController banco:[self.bancosTotal objectAtIndex:i] estaEn:self.seleccionadosIDs]) {
				[self.bancosSeleccionados addObject:[self.bancosTotal objectAtIndex:i]];
			}else {
				[self.bancosNoSeleccionados addObject:[self.bancosTotal objectAtIndex:i]];
			}

		}
	}else{
		self.seleccionadosIDs = [[NSMutableArray alloc] init];
	}
	

	
	
	if ([self.bancosSeleccionados count] > 0) {
		self.opcionesMuestra = self.bancosSeleccionados;
		
	//	self.bancosSeleccionados=[[NSMutableArray alloc] initWithContentsOfFile:[self pathSelectedBanks]];
	//	self.bancosNoSeleccionados = [[NSMutableArray alloc] initWithContentsOfFile:[self pathNoSelectedBanks]];

		if([self.bancosNoSeleccionados count]>0){
			NSMutableDictionary* c = [[NSMutableDictionary alloc] init];
			[c setObject:@"Activo" forKey:@"Seleccionado"] ;
			[c setObject:@"btn_otrosbancossinbrillo.png" forKey:@"ImagenRedonda"];
			[c setObject:@"" forKey:@"ImagenTitulo"];
			[c setObject:@"Otros Bancos" forKey:@"Nombre"];
			[c setObject:@"NNNN" forKey:@"idBanco"];	
			[self.opcionesMuestra addObject:c];
			[c autorelease];
		}
		
		
		//self.otrosBancosTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 79, 320, 380)];
        self.otrosBancosTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 59, 320, IPHONE5_HDIFF(380))];
		self.otrosBancosTable.rowHeight = 54;
		self.otrosBancosTable.backgroundColor = [UIColor clearColor];
		self.otrosBancosTable.tableHeaderView = nil;
		self.otrosBancosTable.delegate =self;
		self.otrosBancosTable.dataSource = self;
		
		
		self.adding  =NO;
		
		
	}else{

		self.opcionesMuestra = self.bancosTotal;

		self.bancosNoSeleccionados = self.opcionesMuestra;
//		self.bancosSeleccionados=[[NSMutableArray alloc] init];
		self.adding  =YES;
	}
    
    sombra.frame = [CommonFunctions frame4inchDisplay:sombra.frame];
	
}


+(BOOL) banco:(NSDictionary*) ban estaEn:(NSArray*) listaB {
	
	for (int i =0; i<[listaB count]; i++) {
		
		NSLog(@"La comparacion es %@",[(NSString*)ban valueForKey:@"idBanco"]);
		if ([[(NSString*)ban valueForKey:@"idBanco"]	isEqualToString:[listaB objectAtIndex:i] ]) {
			return YES;
		}
	
	}
	return NO;
}

 

-(NSString*) pathSelectedBanks{
	NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [path stringByAppendingPathComponent:@"selectedBanks2.plist"];
}

-(NSString*) pathNoSelectedBanks{
	NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [path stringByAppendingPathComponent:@"noselectedBanks2.plist"];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
	CGSize s = listaBancos.contentSize;
    listaBancos.contentSize = CGSizeMake(s.width, IPHONE5_HDIFF(s.height));
    
    if (adding) {
		if([self.bancosNoSeleccionados count] > 0 && [self.bancosSeleccionados count] > 0){
			NSMutableDictionary* c = [[NSMutableDictionary alloc] init];
			[c setObject:@"Activo" forKey:@"Seleccionado"] ;
			[c setObject:@"btn_otrosbancossinbrillo.png" forKey:@"ImagenRedonda"];
			[c setObject:@"" forKey:@"ImagenTitulo"];
			[c setObject:@"Otros Bancos" forKey:@"Nombre"];
			[c setObject:@"NNNN" forKey:@"idBanco"];      
			[self.opcionesMuestra addObject:c];
			[c autorelease];
			[self.listaBancos reloadData];
		}
	}     
	/*
	
	if (adding){

		if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathSelectedBanks]])
		{
			self.bancosSeleccionados=[[NSMutableArray alloc] init];
			self.bancosNoSeleccionados=[[NSMutableArray alloc] init];
			self.seleccionadosIDs = [[NSMutableArray alloc] initWithContentsOfFile:[self pathSelectedBanks]];
			for (int i=0; i<[self.bancosTotal count]; i++)
			{
				if ([self banco:[self.bancosTotal objectAtIndex:i] estaEn:self.seleccionadosIDs]) 
				{
					[self.bancosSeleccionados addObject:[self.bancosTotal objectAtIndex:i]];
				}else 
				{
					[self.bancosNoSeleccionados addObject:[self.bancosTotal objectAtIndex:i]];
				}
				
			}
			self.opcionesMuestra = self.bancosSeleccionados;
			[[Context sharedContext] setBanco:nil];
			[[Context sharedContext] setBancosNoSeleccionados:nil];
			[[Context sharedContext] setBancosSeleccionados:nil];
			if([self.bancosNoSeleccionados count]>0)
			{
				NSMutableDictionary* c = [[NSMutableDictionary alloc] init];
				[c setObject:@"Activo" forKey:@"Seleccionado"] ;
				[c setObject:@"btn_otrosbancossinbrillo.png" forKey:@"ImagenRedonda"];
				[c setObject:@"" forKey:@"ImagenTitulo"];
				[c setObject:@"Otros Bancos" forKey:@"Nombre"];
				[c setObject:@"NNNN" forKey:@"idBanco"];	
				[self.opcionesMuestra addObject:c];
				[c autorelease];
			}
			[self.listaBancos reloadData];
		}
	}else{
			NSString *plistpath = [[NSBundle mainBundle] pathForResource:@"Bancos2" ofType:@"plist"];
			self.opcionesMuestra = [[NSMutableArray alloc] initWithContentsOfFile:plistpath];
			self.bancosNoSeleccionados = self.opcionesMuestra;
			self.bancosSeleccionados=[[NSMutableArray alloc] init];
			self.adding = YES;
			[self.listaBancos reloadData];
			
		}
	*/
}

//--------------------------------------------------------------------
//--------------------------------------------------------------------
//-------------TABLE VIEW DELEGATE & DATA SOURCE----------------------
//--------------------------------------------------------------------
//--------------------------------------------------------------------


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (tableView != self.otrosBancosTable){
		NSLog(@"Pido la lista de opciones muestra = %d", [self.opcionesMuestra count]);
		return [self.opcionesMuestra count];
	}else {
		NSLog(@"Pido la lista de bancosNoSeleccionados = %d", [self.bancosNoSeleccionados count]);
		return [self.bancosNoSeleccionados count];
	}
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   	static NSString *CellIdentifier =@"Banco";
	Banco* bank;
	
	if (tableView != self.otrosBancosTable){
		bank= [[Banco alloc] initWithDictionary:[self.opcionesMuestra objectAtIndex:indexPath.row]];
		
	}else {
		
		bank= [[Banco alloc] initWithDictionary:[self.bancosNoSeleccionados objectAtIndex:indexPath.row]];
		
	}
	
	
    BancoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[BancoCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier nombreBanco:bank.nombre andImageName:bank.imagenRedonda];
		[cell setAccessoryType:UITableViewCellEditingStyleDelete ];
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
		//[[[CustomCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier andImageName:[opcionesMenu objectAtIndex:indexPath.row]] autorelease];
    }else{
		cell.iconoBanco.image = [UIImage imageNamed:bank.imagenRedonda];
		cell.nombreBancoLabel.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        cell.nombreBancoLabel.text = bank.nombre;
	}
	[bank release];
	//cell.label.text = [opcionesMenu objectAtIndex:indexPath.row];
	//cell.imageView.image = [UIImage imageNamed:@"fondoCeldaMenu.png"];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	Banco* bank;
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (tableView != self.otrosBancosTable) {
		bank = [[Banco alloc] initWithDictionary:[self.opcionesMuestra objectAtIndex:indexPath.row]];
	} else {
		bank = [[Banco alloc] initWithDictionary:[self.bancosNoSeleccionados objectAtIndex:indexPath.row]];
		
	}
	
	NSLog(@"Seleccioná el banco = %@",bank.nombre);
	
	if([bank.nombre isEqualToString:@"Otros Bancos"]){
		
		CGFloat y = self.otrosBancosTable.frame.origin.y;
		self.otrosBancosTable.frame = CGRectMake(self.otrosBancosTable.frame.origin.x, 480, self.otrosBancosTable.frame.size.height, self.otrosBancosTable.frame.size.height);
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.35];
		
		[self.view addSubview:self.otrosBancosTable];
		self.otrosBancosTable.frame = CGRectMake(self.otrosBancosTable.frame.origin.x, y, self.otrosBancosTable.frame.size.height, self.otrosBancosTable.frame.size.height);
		self.listaBancos.alpha = 0;
		self.backBoton.alpha = 1;
		self.adding = YES;
		
		[UIView commitAnimations];
		
		return;
	}
	
	Context* context = [Context sharedContext];
	
	if(self.adding) {
		
		NSLog(@"Agrego!");
		if([self.bancosSeleccionados count]>0) {
			
			[self.bancosSeleccionados removeLastObject];//Saco "Otros Bancos antes de grabar"
			
		}
		NSLog(@"ID DEL BANCO %@", [(NSDictionary*)[self.bancosNoSeleccionados objectAtIndex:indexPath.row] objectForKey:@"idBanco"]);
		//[self.seleccionadosIDs addObject:[(NSDictionary*)[self.bancosNoSeleccionados objectAtIndex:indexPath.row] objectForKey:@"idBanco"]];
		//[self.bancosSeleccionados writeToFile:[self pathSelectedBanks] atomically:YES];
		
		//[self.bancosNoSeleccionados removeObjectAtIndex:indexPath.row];
	//[context setBancosNoSeleccionados:self.bancosNoSeleccionados];
		//[self.bancosNoSeleccionados writeToFile:[self pathNoSelectedBanks] atomically:YES];
		
		[context setBancosSeleccionados:self.seleccionadosIDs];

	}
	
	
	NSLog(@"Voy a agregarlo al context! con nombre = %@ y titulo = %@",bank.nombre,bank.imagenTitulo);
	[context setBanco:bank];
	NSLog(@"AGREGADO!");
	
	LoginController* p1 = [[LoginController alloc] initPrimerLoginConBanco:adding];
	p1.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:p1 animated:YES];
	//[p1 autorelease];
	
}


//--------------------------------------------------------------------
//--------------------------------------------------------------------
//--------------------------------------------------------------------
//--------------------------------------------------------------------


-(IBAction) backBancosSeleccionados{
	
	[self.otrosBancosTable removeFromSuperview];
	self.backBoton.alpha = 0;
	self.listaBancos.alpha = 1; 
	self.adding = NO;
}



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[backBoton release];
	[otrosBancosTable release];
	[listaBancos release];
	[bancosNoSeleccionados release];
	[bancosSeleccionados release];
	[bancosTotal release];
	[opcionesMuestra release];
	[seleccionadosIDs release];
    self.sombra = nil;
    [super dealloc];
}


@end
