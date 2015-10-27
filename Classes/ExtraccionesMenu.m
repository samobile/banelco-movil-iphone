//
//  ExtraccionesMenu.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/8/15.
//
//

#import "ExtraccionesMenu.h"
#import "MenuOptionsHelper.h"
#import "MenuOption.h"
#import "CommonUIFunctions.h"
#import "MenuBanelcoController.h"

#import "GAITracker.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#import "ExtraccionesImporte.h"
#import "ExtraccionesConsultas.h"

@interface ExtraccionesMenu ()

@end

@implementation ExtraccionesMenu

- (void)GAItrack {
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Pantalla Extracciones"];
    // New SDK versions
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (id) init {
    if ((self = [super init])) {
        self.title = @"Extracciones";
        
    }
    return self;
}

- (void)aceptar:(int)cellIdx {
    
    int selectedIndex = [self getSelectedIndex:cellIdx];
    
    if (selectedIndex == EXTRACCION_PROPIA) {
        ExtraccionesImporte *e = [[ExtraccionesImporte alloc] init];
        e.extraTerceros = NO;
        [[MenuBanelcoController sharedMenuController] pushScreen:e];
        
    } else if (selectedIndex == EXTRACCION_TERCERO) {
        ExtraccionesImporte *e = [[ExtraccionesImporte alloc] init];
        e.extraTerceros = YES;
        [[MenuBanelcoController sharedMenuController] pushScreen:e];
        
    } else if (selectedIndex == EXTRACCION_CONSULTA) {
        ExtraccionesConsultas *e = [[ExtraccionesConsultas alloc] init];
        [[MenuBanelcoController sharedMenuController] pushScreen:e];
        
    }
    else {
        
    }
    
}

- (void)initOptions {
    
    [super.options removeAllObjects];
    
    MenuOptionsHelper *helper = [MenuOptionsHelper sharedMenuHelper];
    
    if ([helper isEnabled:EXTRACCION_PROPIA]) {
        [super.options addObject:[[MenuOption alloc] initWithOption:EXTRACCION_PROPIA andTitle:@"Extracciones Propias"]];
    }
    if ([helper isEnabled:EXTRACCION_TERCERO]) {
        [super.options addObject:[[MenuOption alloc] initWithOption:EXTRACCION_TERCERO andTitle:@"Extracciones para Terceros"]];
    }
    if ([helper isEnabled:EXTRACCION_CONSULTA]) {
        [super.options addObject:[[MenuOption alloc] initWithOption:EXTRACCION_CONSULTA andTitle:@"Consultas"]];
    }
    
    [super.tableView reloadData];
    
}

-(void) viewDidLoad{
    
    [super viewDidLoad];
    self.title = @"Extracciones";
    self.title.accessibilityLabel = @"Submenú extracciones";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
