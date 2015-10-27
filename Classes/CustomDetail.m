//
//  CustomDetail.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomDetail.h"
#import "CustomDetailCell.h"
#import "Context.h"
#import "CommonFunctions.h"

@implementation CustomDetail

@synthesize titulos, datos, tableView;


- (id)init {
    if ((self = [super initWithNibName:@"CustomDetail" bundle:nil])) {
		
		titulos = [[NSMutableArray alloc] init];
		datos = [[NSMutableArray alloc] init];
		
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
		
	self.tableView.backgroundColor = [UIColor clearColor];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return self.titulos? [self.titulos count] : 0;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *CellIdentifier = @"Cell";
	NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%i",indexPath.row];
	
    CustomDetailCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CustomDetailCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
        
    }
    
	if (indexPath.row == 0) {
		[cell esTitulo];
	} else {
		
		cell.titulo.text = [NSString stringWithFormat:@"%@:", [self.titulos objectAtIndex:indexPath.row]];
	}
	
	cell.dato.text = [self.datos objectAtIndex:indexPath.row];
	
	//personalizacion
	cell.dato.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"DetalleTxtColor"];
    
    cell.dato.accessibilityLabel = [CommonFunctions replaceSymbolVoice:cell.dato.text];
    cell.titulo.accessibilityLabel = [CommonFunctions replaceSymbolVoice:cell.titulo.text];
    
    return cell;
}



- (void)dealloc {
    [super dealloc];
	[titulos release];
	[datos release];
}


@end
