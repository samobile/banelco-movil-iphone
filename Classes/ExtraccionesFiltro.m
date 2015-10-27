//
//  ExtraccionesFiltro.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/16/15.
//
//

#import "ExtraccionesFiltro.h"
#import "Context.h"
#import "CommonFunctions.h"
#import "CommonUIFunctions.h"
#import "ExtraccionesConsultas.h"
#import "MenuBanelcoController.h"

@interface ExtraccionesFiltro ()

@end

@implementation ExtraccionesFiltro

@synthesize barTeclado, dniTxt, subMenuDNI, barTecladoButton, lTipoDoc, subMenuEstados, lEstado, consultasDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Consultas";
    tipoSeleccionado = 0;
    estadoSeleccionado = 0;
    if (![Context sharedContext].personalizado) {
        dniTxt.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        lTipoDoc.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
        lEstado.font = [UIFont fontWithName:@"BanelcoBeau-Regular" size:17];
    }
    UIImageView *barTecladoIm = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barra_teclado.png"]];
    self.barTecladoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barTecladoButton.frame = CGRectMake(222, 8, 88, 29);
    [barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
    barTecladoButton.accessibilityLabel = @"Aceptar";
    [barTecladoButton setTitle:@"" forState:UIControlStateNormal];
    [barTecladoButton addTarget:self action:@selector(closeKeyb:) forControlEvents:UIControlEventTouchUpInside];
    
    self.barTeclado = [[[UIView alloc] initWithFrame:CGRectMake(0, IPHONE5_HDIFF(480), barTecladoIm.bounds.size.width, barTecladoIm.bounds.size.height)] autorelease];
    self.barTeclado.backgroundColor = [UIColor clearColor];
    [self.barTeclado addSubview:barTecladoIm];
    [barTecladoIm release];
    [self.barTeclado addSubview:barTecladoButton];
    [self.view addSubview:self.barTeclado];
    
    // Tipo Documento
    self.subMenuDNI = [[[UIActionSheet alloc] init] autorelease];
    NSArray *elemTipoDoc = [NSArray arrayWithObjects:@"DNI", @"CI", @"PAS", @"LC", @"LE", nil];
    for (NSString *el in elemTipoDoc) {
        [subMenuDNI addButtonWithTitle:el];
    }
    subMenuDNI.delegate = self;
    
    // Estado
    self.subMenuEstados = [[[UIActionSheet alloc] init] autorelease];
    NSArray *elemEstados = [NSArray arrayWithObjects:@"Todos los Estados", @"Pendiente", @"Cancelado", @"Bloqueado", @"Cobrado", @"Vencido", nil];
    for (NSString *el in elemEstados) {
        [subMenuEstados addButtonWithTitle:el];
    }
    subMenuEstados.delegate = self;
}

- (void)closeKeyb:(UIButton *)btn {
    [self dismissAll];
}

- (IBAction)cambiarTipoDocumento {
    
    [self dismissAll];
    
    if (subMenuDNI.numberOfButtons > 0) {
        [subMenuDNI showInView:self.view];
    }
}

- (IBAction)cambiarTipoEstado {
    
    [self dismissAll];
    
    if (subMenuEstados.numberOfButtons > 0) {
        [subMenuEstados showInView:self.view];
    }
}

//// ACTION SHEET DELEGATE //////////////////////////////////////////////

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet == subMenuDNI) {
        
        self.lTipoDoc.text = [subMenuDNI buttonTitleAtIndex:buttonIndex];
        tipoSeleccionado = buttonIndex;
        
    }
    else if (actionSheet == subMenuEstados) {
        
        self.lEstado.text = [subMenuEstados buttonTitleAtIndex:buttonIndex];
        estadoSeleccionado = buttonIndex;
        
    }
    
}

- (void)dismissAll {
    if ([self.dniTxt isFirstResponder]) {
        [self.dniTxt resignFirstResponder];
    }
}

- (NSString *)getNombreStatus:(int)tipo {
    NSString *n = nil;
    switch (tipo) {
        case 0:
            n = @"Todos los Estados"; //-1
            break;
        case 1:
            n = @"Pendiente";
            break;
        case 2:
            n = @"Cancelado";
            break;
        case 3:
            n = @"Bloqueado";
            break;
        case 4:
            n = @"Cobrado";
            break;
        case 5:
            n = @"Vencido";
            break;
        default:
            n = @"";
            break;
    }
    return n;
}

- (NSString *)getNombreTipo:(int)tipo {
    NSString *n = nil;
    switch (tipo) {
        case 1:
            n = @"DNI";
            break;
        case 2:
            n = @"CI";
            break;
        case 3:
            n = @"PAS";
            break;
        case 4:
            n = @"LC";
            break;
        case 5:
            n = @"LE";
            break;
        default:
            n = @"";
            break;
    }
    return n;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    [barTecladoButton setImage:[UIImage imageNamed:@"btn_TecAceptar.png"] forState:UIControlStateNormal];
    barTecladoButton.accessibilityLabel = @"Aceptar";
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    
    CGFloat y = 0;
    self.barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(114) + y, self.barTeclado.frame.size.width, self.barTeclado.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    
    self.barTeclado.frame = CGRectMake(0, IPHONE5_HDIFF(480), self.barTeclado.frame.size.width, self.barTeclado.frame.size.height);
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == dniTxt) {
        
        if (![CommonFunctions hasNumbers:string]) {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

- (IBAction)filtrarAccion:(id)sender {

    self.consultasDelegate.statusFilter = [NSString stringWithFormat:@"%li", estadoSeleccionado - 1];
    if ([dniTxt.text length] > 0) {
        self.consultasDelegate.dniFilter = self.dniTxt.text;
        self.consultasDelegate.dniTipoFilter = [NSString stringWithFormat:@"%li", tipoSeleccionado + 1];
    }
    else {
        self.consultasDelegate.dniFilter = nil;
        self.consultasDelegate.dniTipoFilter = nil;
    }
    [[MenuBanelcoController sharedMenuController] volver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.lEstado = nil;
    self.barTeclado = nil;
    self.dniTxt = nil;
    self.subMenuDNI = nil;
    self.barTecladoButton = nil;
    self.lTipoDoc = nil;
    self.subMenuEstados = nil;
    self.consultasDelegate = nil;
    [super dealloc];
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
