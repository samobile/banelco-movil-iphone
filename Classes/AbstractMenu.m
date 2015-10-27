//
//  CustomList.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AbstractMenu.h"
#import "CustomCell.h"
#import "MenuOption.h"
#import "CommonFunctions.h"
#import "Context.h"

@implementation AbstractMenu

@synthesize tableView, options, bgImage, itemImage;

int const AM_FUCSIA = 0;
int const AM_AZUL = 1;
int const AM_VIOLETA = 2;
int const AM_VERDE = 3;


#pragma mark -
#pragma mark View lifecycle

- (id) initWithColor:(int)color {
	
	if ((self = [super initWithNibName:@"AbstractMenu" bundle:nil])) {
		
		self.tableView.backgroundColor = [UIColor clearColor];
		
		self.bgImage = [UIImage imageNamed:@"btn_barramenu.png"];
		
		if (color == AM_FUCSIA) {
			self.itemImage = [UIImage imageNamed:@"btn_consultasmenu.png"];
		} else if (color == AM_AZUL) {
			self.itemImage = [UIImage imageNamed:@"btn_pmcmenu.png"];
		} else if (color == AM_VIOLETA) {
			self.itemImage = [UIImage imageNamed:@"btn_recargamenu.png"];
		} else if (color == AM_VERDE) {
			self.itemImage = [UIImage imageNamed:@"btn_transfmenu.png"];
		} else {
			self.itemImage = [UIImage imageNamed:@"btn_pmcmenu.png"];
		}

		topMargin = 6;
		margin = 6;
		
		self.tableView.rowHeight = self.bgImage.size.height + margin;
		
		self.options = [[NSMutableArray alloc] init];
		[self initOptions];
		
	}
	return self;
}

-(id) init {
	
	return [self initWithColor:1];
	
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.sectionHeaderHeight = 4;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //CGRect r = self.tableView.frame;
    //self.tableView.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, IPHONE5_HDIFF(r.size.height));
}



/*- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
	//self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"fnd_app.png"]];
}*/

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return options? [options count] : 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CustomCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier withBgImage:bgImage] autorelease];
    }
	
	cell.itemIcon.image = self.itemImage;
	
	//personalizacion
	cell.itemText.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"MenuTxtColor"];

	cell.itemText.text = [[options objectAtIndex:indexPath.row] title];
    
    return cell;
	
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
	[tableView deselectRowAtIndexPath:[NSIndexPath indexPathWithIndex:indexPath] animated:NO];

	[tableView reloadData];
	
	[self aceptar:indexPath.row];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
    return topMargin;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

	return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, topMargin)];

}


- (void)aceptar:(int)cellIdx {}

- (int)getSelectedIndex:(int)selectedCellIdx {

	return [(MenuOption *)[options objectAtIndex:selectedCellIdx] option];

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

