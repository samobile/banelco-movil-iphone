//
//  CustomDatePicker.m
//  BanelcoMovilIphone
//
//  Created by German Levy on 6/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomDatePicker.h"
#import "Context.h"


@implementation CustomDatePicker

@synthesize meses, anios, anioActual;

int anchoMes = 150;
int anchoAnio = 90;
int altoElemento = 44;
int espacio = 15;

int anioInicial = 2000;
//int anioActual = 0;
int cantAnios = 90;


- (id)init {
    if ((self = [super init])) {
		
		self.meses = [NSArray arrayWithObjects:@"enero", @"febrero", @"marzo", @"abril", @"mayo", @"junio", @"julio", @"agosto", @"septiembre", @"octubre", @"noviembre", @"diciembre", nil];
		
		self.anios = [[NSMutableArray alloc] init];
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
		self.anioActual = [components year];
		[gregorian dealloc];
		for (int i=anioInicial; i < anioActual+cantAnios; i++) {
			[anios addObject:[NSString stringWithFormat:@"%i", i]];
		}
			 
		self.delegate = self;
		self.dataSource = self;
		
		[self iniciar];
		
    }
    return self;
}

- (void)iniciar {
    
    if ([Context sharedContext].personalizado) {
        NSString *idBco = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"Personalizacion"] objectForKey:@"idBanco"];
        if ([idBco isEqualToString:@"IBAY"]) {
            [self selectRow:11 inComponent:0 animated:NO];
            [self selectRow:2050-anioInicial inComponent:1 animated:NO];
            return;
        }
    }
    [self selectRow:6 inComponent:0 animated:NO];
    [self selectRow:anioActual-anioInicial inComponent:1 animated:NO];
}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (component == 0) {
		return 12;
		//return NSIntegerMax;
	} else {
		return anioActual - anioInicial + cantAnios;
	}

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}


#pragma mark -
#pragma mark UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	if (component == 0) {
		return anchoMes;
	} else if (component == 1) {
		return anchoAnio;
	}
}
 
 - (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return altoElemento;
}
 
 // Tell the picker which view to use for a given component and row, we have an array of views to show
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
		  forComponent:(NSInteger)component reusingView:(UIView *)view
{
	BOOL highlighted = NO;
	
	if (component == 0) {
		view = [[UILabel alloc] initWithFrame:CGRectMake(espacio, 0, anchoMes-espacio, altoElemento)];
		((UILabel *)view).textAlignment = UITextAlignmentLeft;
		//((UILabel *)view).text = [meses objectAtIndex:(row % [self.meses count])];
		((UILabel *)view).text = [meses objectAtIndex:row];
		highlighted = [self selectedRowInComponent:0] == row;
	} else if (component == 1) {
		view = [[UILabel alloc] initWithFrame:CGRectMake(-espacio, 0, anchoAnio-espacio, altoElemento)];
		((UILabel *)view).textAlignment = UITextAlignmentCenter;
		((UILabel *)view).text = [anios objectAtIndex:row];
		highlighted = [self selectedRowInComponent:1] == row;
	}
	((UILabel *)view).font = [UIFont boldSystemFontOfSize:25.0];
//	((UILabel *)view).highlightedTextColor = [UIColor blueColor];
//	((UILabel *)view).highlighted = highlighted;
	view.backgroundColor = [UIColor clearColor];
	
	return view;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//
//	if (component == 0) {
//		return [self.meses objectAtIndex:row];
//	} else if (component == 1) {
//		return [self.anios objectAtIndex:row];
//	}
//	
//}


-(NSString *)getDateString {

	int selectedMonth = [self selectedRowInComponent:0] + 1;
	NSString *monthString = [NSString stringWithFormat:@"%i", selectedMonth];
	if([monthString length] < 2) {
		monthString = [NSString stringWithFormat:@"0%@", monthString];
	}
	int selectedYear = [self selectedRowInComponent:1];
	//NSString *yearString = [[anios objectAtIndex:selectedYear] substringFromIndex:2];
	NSString *yearString = [anios objectAtIndex:selectedYear];
	
	return [NSString stringWithFormat:@"%@/%@", monthString, yearString];

}


- (void)dealloc {
	[meses dealloc];
	[anios dealloc];
    [super dealloc];
}


@end
