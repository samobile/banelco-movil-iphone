//
//  SearchTable.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 9/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchTableController.h"
#import "Context.h"

@implementation SearchTableController

@synthesize sourceKeys, filteredKeys, sourceDictionary, searchBar, tableView;


- (id)init {
    if ((self = [super initWithNibName:@"SearchTable" bundle:nil])) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Configura el boton del teclado con leyenda "Aceptar"
	for (UIView *searchBarSubview in [searchBar subviews]) {
		if ([searchBarSubview isKindOfClass:[UITextField class]]) {
            UITextField *searchField = (UITextField *)searchBarSubview;
            searchField.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
            @try {
				[(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
			}
			@catch (NSException * e) {
				// ignore exception
			}
        }
        
//        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
//			@try {
//				[(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
//			}
//			@catch (NSException * e) {
//				// ignore exception
//			}
//		}
	}
}

- (NSComparisonResult)compare:(id)otherObject {
	
    return [self compare:otherObject];
	
}


#pragma mark -
#pragma mark SearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	
	if ([searchText length] > 0) {
		
		// Predicate
		NSString *format = [NSString stringWithFormat:@"SELF beginswith[c] '%@'", searchText];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
		self.filteredKeys = [self.sourceKeys filteredArrayUsingPredicate:predicate];
		
	} else {
		
		self.filteredKeys = [NSArray arrayWithArray:self.sourceKeys];
		
	}

	[self.tableView reloadData];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredKeys? [self.filteredKeys count] : 0;
}


#pragma mark -
#pragma mark Table view data source

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellEditingStyleDelete];
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.backgroundColor = [UIColor clearColor];
    }
	if (![Context sharedContext].personalizado) {
        cell.textLabel.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
	cell.textLabel.text = [self.filteredKeys objectAtIndex:indexPath.row];
	cell.textColor = [[Context sharedContext] UIColorFromRGBProperty:@"TxtColor"];
    
    return cell;
	
}


- (id)getItem:(int)idx {

	return [self.sourceDictionary objectForKey:[self.filteredKeys objectAtIndex:idx]];

}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

	[searchBar resignFirstResponder];

}

- (void) dismissAll {
	if ([searchBar isFirstResponder]) {
		[searchBar resignFirstResponder];
	}
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

	[self dismissAll];

}


//Agregado para cerrar el teclado si se toca cualquier parte de la pantalla
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if ([self respondsToSelector:@selector(dismissAll)]) {
		[self performSelector:@selector(dismissAll)];
	}
		
    [super touchesBegan:touches withEvent:event];    
}



- (void)dealloc {
    [super dealloc];
}


@end
