//
//  ExtraccionesConsultas.m
//  BanelcoMovilIphone
//
//  Created by Sebastian Alonso on 10/15/15.
//
//

#import "ExtraccionesConsultas.h"
#import "MandatoViewCell.h"
#import "ExtraccionesMandato.h"
#import "MenuBanelcoController.h"
#import "WS_ConsultarMandatos.h"
#import "MandatoBeanMobile.h"
#import "MandatarioBeanMobile.h"
#import "WSUtil.h"
#import "Context.h"
#import "MandatarioMobileDTO.h"
#import "TerminalMobileDTO.h"
#import "CommonUIFunctions.h"
#import "ExtraccionesFiltro.h"
#import "CommonFunctions.h"

@interface ExtraccionesConsultas ()

@end

@implementation ExtraccionesConsultas

@synthesize tableMandatos, mandatos, dniFilter, statusFilter, inicio, dniTipoFilter, ejecutarConsulta;

NSComparisonResult sortMandatos(MandatoBeanMobile *st1, MandatoBeanMobile *st2, void *ignore)
{
    return [[CommonFunctions NSStringToNSDate:st2.fechaAlta withFormat:[CommonFunctions WSFormatProfileDOBInSpanish]] compare:[CommonFunctions NSStringToNSDate:st1.fechaAlta withFormat:[CommonFunctions WSFormatProfileDOBInSpanish]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.ejecutarConsulta = YES;
    selectedRow = -1;
    
    self.statusFilter = nil;
    self.dniTipoFilter = nil;
    self.dniFilter = nil;
    
    self.title = @"Consultas";
    self.tableMandatos.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.inicio = [UIButton buttonWithType:UIButtonTypeCustom];
    inicio.frame = CGRectMake(250, 36, 60,27);
    inicio.accessibilityLabel = @"Filtrar";
    [inicio setBackgroundImage:[UIImage imageNamed:@"bt_filtro.png"] forState:UIControlStateNormal];
    [inicio setBackgroundImage:[UIImage imageNamed:@"bt_filtroselec.png"] forState:UIControlStateHighlighted];
    [inicio addTarget:self action:@selector(filtrarAccion) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
    [win addSubview:inicio];
}

- (void)screenWillBeBack {
    if (!self.inicio) {
        self.inicio = [UIButton buttonWithType:UIButtonTypeCustom];
        inicio.frame = CGRectMake(250, 36, 60,27);
        inicio.accessibilityLabel = @"Filtrar";
        [inicio setBackgroundImage:[UIImage imageNamed:@"bt_filtro.png"] forState:UIControlStateNormal];
        [inicio setBackgroundImage:[UIImage imageNamed:@"bt_filtroselec.png"] forState:UIControlStateHighlighted];
        [inicio addTarget:self action:@selector(filtrarAccion) forControlEvents:UIControlEventTouchUpInside];
        UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
        [win addSubview:inicio];
    }
    
    
    [self inicializar];
}

//- (void)aplicarFiltro {
//    
//}

- (void)screenDidBack {
    [self.inicio removeFromSuperview];
    self.inicio = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.inicio removeFromSuperview];
    self.inicio = nil;
}

- (void)filtrarAccion {
    ExtraccionesFiltro *ef = [[ExtraccionesFiltro alloc] init];
    ef.consultasDelegate = self;
    [[MenuBanelcoController sharedMenuController] pushScreen:ef];
}

- (void)accionWithDelegate:(WheelAnimationController *)delegate {
    
    self.mandatos = nil;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    WS_ConsultarMandatos *request = [[WS_ConsultarMandatos alloc] init];
    request.userToken = [[Context sharedContext] getToken];
    request.codBanco = [Context sharedContext].banco.idBanco;
    MandatarioMobileDTO *mandatario = [[MandatarioMobileDTO alloc] init];
    mandatario.tipoDocMandatario = [Context sharedContext].usuario.tipoDocumento;
    mandatario.nroDocMandatario = [Context sharedContext].usuario.nroDocumento;
    mandatario.tipoCuentaMandatario = nil;
    mandatario.nroCuentaMandatario = nil;
    request.mandatario = mandatario;
    [mandatario release];
    TerminalMobileDTO *ter = [[TerminalMobileDTO alloc] init];
    ter.terminal = nil;
    ter.datosTerminal = nil;
    ter.canal = @"O";
    ter.direccionIp = [WSRequest securityToken];
    request.terminal = ter;
    [ter release];
    
    id resultWS = [WSUtil execute:request];
    
    [request release];
    
    if ([resultWS isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *result = nil;
        if (self.statusFilter) {
            result = [self filtrarResultados:resultWS];
        }
        else {
            result = [NSMutableArray arrayWithArray:(NSMutableArray *)resultWS];
        }
        
        result = [result sortedArrayUsingFunction:sortMandatos context:nil];
        
//        self.statusFilter = nil;
//        self.dniTipoFilter = nil;
//        self.dniFilter = nil;
        
        if ([result count] == 0) {
            [CommonUIFunctions showAlert:self.title withMessage:@"No hay resultados para el filtro seleccionado." cancelButton:@"Aceptar" andDelegate:nil];
            [self performSelectorOnMainThread:@selector(reloadTableData) withObject:nil waitUntilDone:NO];
            [delegate accionFinalizada:TRUE];
            resultWS = nil;
            [pool release];
            return;
        }
        
        self.mandatos = result;//[NSMutableArray arrayWithArray:result];
    }
    else if ([resultWS isKindOfClass:[NSError class]]) {
        NSString *errorCode = [[(NSError *)resultWS userInfo] valueForKey:@"faultCode"];
        if ([errorCode isEqualToString:@"ss"]) {
            [delegate accionFinalizada:FALSE];
            resultWS = nil;
            [pool release];
            return;
        }
        NSString *errorDesc = [[(NSError *)resultWS userInfo] valueForKey:@"description"];
        [CommonUIFunctions showAlert:self.title withMessage:errorDesc cancelButton:@"Aceptar" andDelegate:nil];
        [delegate accionFinalizada:FALSE];
        resultWS = nil;
        [pool release];
        return;
    }
    else {
        [CommonUIFunctions showAlert:self.title withMessage:@"En este momento no se puede realizar la operación. Reintenta más tarde." cancelButton:@"Aceptar" andDelegate:nil];
        [delegate accionFinalizada:FALSE];
        resultWS = nil;
        [pool release];
        return;
    }
    
    NSLog(@"acaaaaaaa");
    
    [self performSelectorOnMainThread:@selector(reloadTableData) withObject:nil waitUntilDone:NO];
    [delegate accionFinalizada:TRUE];
    
    resultWS = nil;
    
    [pool release];
}

- (void)reloadTableData {
    [self.tableMandatos reloadData];
}

- (NSMutableArray *)filtrarResultados:(NSMutableArray *)res {
    
    NSMutableArray *r = [[[NSMutableArray alloc] init] autorelease];
    for (MandatoBeanMobile *m in res) {
        if (self.dniFilter) {
            if ([self.dniFilter isEqualToString:m.numeroDocumentoBeneficiario] && [self.dniTipoFilter isEqualToString:m.tipoDocumentoBeneficiario] && ([self.statusFilter isEqualToString:@"-1"] || [self.statusFilter isEqualToString:m.estado])) {
                [r addObject:m];
            }
        }
        else if ([self.statusFilter isEqualToString:@"-1"] || [self.statusFilter isEqualToString:m.estado]) {
            [r addObject:m];
        }
    }
    return r;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mandatos ? [self.mandatos count] : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableV cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    
    UITableViewCell *cell = [tableV dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    UIView *v = [cell.contentView viewWithTag:10];
    if (v) {
        [v removeFromSuperview];
    }
    MandatoViewCell *m = [[[MandatoViewCell alloc] initWithNibName:@"MandatoViewCell" bundle:nil] autorelease];
    [cell.contentView addSubview:m.view];
    m.view.tag = 10;
    MandatoBeanMobile *man = [self.mandatos objectAtIndex:indexPath.row];
    m.fechaLbl.text = [NSString stringWithFormat:@"%@", man.fechaAlta];
    m.dniLbl.text = [NSString stringWithFormat:@"%@ %@", [self getNombreTipo:[man.tipoDocumentoBeneficiario intValue]], man.numeroDocumentoBeneficiario];
    m.statusLbl.text = [NSString stringWithFormat:@"%@", [self getNombreStatus:[man.estado intValue]]];
    m.montoLbl.text = [NSString stringWithFormat:@"$ %@", [man.montoMandato stringByReplacingOccurrencesOfString:@"." withString:@","]];
    
    return cell;
}

- (NSString *)getNombreStatus:(int)tipo {
    NSString *n = nil;
    switch (tipo) {
        case 0:
            n = @"Pendiente";
            break;
        case 1:
            n = @"Cancelado";
            break;
        case 2:
            n = @"Bloqueado";
            break;
        case 3:
            n = @"Cobrado";
            break;
        case 4:
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

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MandatoBeanMobile *m = [self.mandatos objectAtIndex:indexPath.row];
    selectedRow = indexPath.row;
    ExtraccionesMandato *r = [[ExtraccionesMandato alloc] initWithTitle:self.title];
    r.mandatoBean = m;
    [[MenuBanelcoController sharedMenuController] pushScreen:r];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.tableMandatos = nil;
    self.mandatos = nil;
    self.dniFilter = nil;
    self.statusFilter = nil;
    self.inicio = nil;
    self.dniTipoFilter = nil;
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
