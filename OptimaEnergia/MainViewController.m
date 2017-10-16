//
//  MainViewController.m
//  OptimaEnergia
//
//  Created by Juan Pestana on 4/3/13.
//  Copyright (c) 2013 Juan Pestana. All rights reserved.
//

#import "MainViewController.h"
#import "AudioToolbox/AudioToolbox.h"

@interface MainViewController (){
    NSMutableArray *arrayOfLocation;
    sqlite3 *OeCensoFinal;
    NSString *dbPathString;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    CLLocationManager *startlocation;
}

@end

@implementation MainViewController

@synthesize pickerluminarias, entries, codigoLuminaria;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createOrOpenDB];
    [self updateTime];
    entries = [[NSMutableArray alloc]init];
    _mapViewcenso.delegate = self;
   	locationManager = [[CLLocationManager alloc]init];
    geocoder = [[CLGeocoder alloc]init];
    [[self tableView]setDelegate:self];
    [[self tableView]setDataSource:self];
    
    _ipadid.text = @"OE_COO";
    
    [locationManager startUpdatingLocation];
    startlocation = nil;
    
    searchResults = [[NSMutableArray alloc]init];
    
    arrayOfLocation = [[NSMutableArray alloc]init];
    locationManager = [[CLLocationManager alloc]init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    arraytecnologia = [[NSMutableArray alloc]init];
    [arraytecnologia addObject:@"TECNOLOGIA"];
    [arraytecnologia addObject:@"VSAP"];
    [arraytecnologia addObject:@"LED"];
    [arraytecnologia addObject:@"INDUC"];
    [arraytecnologia addObject:@"AM"];
    [arraytecnologia addObject:@"AMC"];
    [arraytecnologia addObject:@"OTRO"];
    [arraytecnologia addObject:@"CIRCUITO"];
    
    arraypotencia = [[NSMutableArray alloc]init];
    [arraypotencia addObject:@"POTENCIA"];
    [arraypotencia addObject:@"25"];
    [arraypotencia addObject:@"40"];
    [arraypotencia addObject:@"70"];
    [arraypotencia addObject:@"100"];
    [arraypotencia addObject:@"120"];
    [arraypotencia addObject:@"150"];
    [arraypotencia addObject:@"200"];
    [arraypotencia addObject:@"250"];
    [arraypotencia addObject:@"300"];
    [arraypotencia addObject:@"400"];
    [arraypotencia addObject:@"1000"];
    [arraypotencia addObject:@"OTRO"];
    
    arraytipoPoste = [[NSMutableArray alloc]init];
    [arraytipoPoste addObject:@"POSTE"];
    [arraytipoPoste addObject:@"Metal"];
    [arraytipoPoste addObject:@"Madera"];
    [arraytipoPoste addObject:@"Concreto"];
    [arraytipoPoste addObject:@"Colonial"];
    [arraytipoPoste addObject:@"Punta"];
    [arraytipoPoste addObject:@"Muro"];
    [arraytipoPoste addObject:@"OTRO"];
    
    arraytipoBrazo = [[NSMutableArray alloc]init];
    [arraytipoBrazo addObject:@"BRAZO"];
    [arraytipoBrazo addObject:@"Simple.L"];
    [arraytipoBrazo addObject:@"Simple.C"];
    [arraytipoBrazo addObject:@"Doble"];
    [arraytipoBrazo addObject:@"Colonial-I"];
    [arraytipoBrazo addObject:@"Colonial-II"];
    [arraytipoBrazo addObject:@"Cuadrado"];
    [arraytipoBrazo addObject:@"Desnivel"];
    [arraytipoBrazo addObject:@"Ninguno"];
    [arraytipoBrazo addObject:@"OTRO"];
    
    arraytipoLuminaria = [[NSMutableArray alloc]init];
    [arraytipoLuminaria addObject:@"LUMINARIA"];
    [arraytipoLuminaria addObject:@"Cobra"];
    [arraytipoLuminaria addObject:@"Mongoose"];
    [arraytipoLuminaria addObject:@"PuntaPoste"];
    [arraytipoLuminaria addObject:@"CajaZapato"];
    [arraytipoLuminaria addObject:@"Reflector"];
    [arraytipoLuminaria addObject:@"OTRO"];
    
    
    
    arraycircuito = [[NSMutableArray alloc]init];
    [arraycircuito addObject:@"CIRCUITO"];
    [arraycircuito addObject:@"NM"];
    for (int i=0; i<1500; i++) {
        [arraycircuito addObject:[NSString stringWithFormat:@"CM%d", i+1]];
    }
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open([dbPathString UTF8String], &OeCensoFinal)==SQLITE_OK) {
        [arrayOfLocation removeAllObjects];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM CENSOFINALOE"];
        const char* query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(OeCensoFinal, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
               // NSString *unico = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSString *idluminaria = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 20)];
                NSString *identificador = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSString *tecnologia = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                NSString *potencia = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
                NSString *poste = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)];
                NSString *brazo = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 15)];
                NSString *luminaria = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 16)];
                NSString *circuito = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 17)];
                
                Location *location = [[Location alloc]init];
                
                [location setIdentificador:identificador];
                [location setTecnologia:tecnologia];
                [location setPotencia:potencia];
                [location setTipoPoste:poste];
                [location setTipoBrazo:brazo];
                [location setTipoLuminaria:luminaria];
                [location setCircuito:circuito];
                [location setIdlum:idluminaria];
                
                [arrayOfLocation addObject:location];
                
                
                NSString *str = [[NSString alloc]initWithFormat:@"%@ - %@ - %@ - %@ - %@ - %@",tecnologia, potencia, poste, brazo, luminaria, circuito];
                [entries addObject:str];
            }
        }
    }
    [[self tableView]reloadData];

}


-(void)createOrOpenDB{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    dbPathString = [docPath stringByAppendingPathComponent:@"OeCensoFinal.db"];
    
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath = [dbPathString UTF8String];
        
        if (sqlite3_open(dbPath, &OeCensoFinal)==SQLITE_OK) {
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CENSOFINALOE (ID INTEGER PRIMARY KEY AUTOINCREMENT, FECHA TEXT, HORA TEXT,  LATITUDE TEXT, LONGITUDE TEXT, CALLE TEXT, NUMERO TEXT, CIUDAD TEXT, RESERVA1 TEXT, RESERVA2 TEXT, CANALES TEXT, IDENTIFICADOR TEXT, TECNOLOGIA TEXT, POTENCIA TEXT, TIPOPOSTE TEXT, TIPOBRAZO TEXT, TIPOLUMINARIA TEXT, CIRCUITO TEXT, FUNCIONA TEXT, MEDIDOR TEXT, IDLUM)";
            sqlite3_exec(OeCensoFinal, sql_stmt, NULL, NULL, &error);
            sqlite3_close(OeCensoFinal);
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [arrayOfLocation count];
    }


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    Location *aLocation = [arrayOfLocation objectAtIndex:indexPath.row];
    
    
    
    NSString *titulo = [[NSString alloc]initWithFormat:@"%@ - %@ /    #Carriles: %@",aLocation.idlum, aLocation.identificador, aLocation.canales];

    
    cell.textLabel.text = titulo;
    cell.detailTextLabel.text = [self.entries objectAtIndex:indexPath.row];
    
    
    return cell;
    
}










/*------------------------*/

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 6;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == TECNOLOGIA)
        return [arraytecnologia count];
    if (component == POTENCIA)
        return [arraypotencia count];
    if (component == TIPOPOSTE)
        return [arraytipoPoste count];
    if (component == TIPOBRAZO)
        return [arraytipoBrazo count];
    if (component == TIPOLUMINARIA)
        return [arraytipoLuminaria count];
    if (component == CIRCUITO)
        return [arraycircuito count];
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == TECNOLOGIA)
        return [arraytecnologia objectAtIndex:row];
    if (component == POTENCIA)
        return [arraypotencia objectAtIndex:row];
    if (component == TIPOPOSTE)
        return [arraytipoPoste objectAtIndex:row];
    if (component == TIPOBRAZO)
        return [arraytipoBrazo objectAtIndex:row];
    if (component == TIPOLUMINARIA)
        return [arraytipoLuminaria objectAtIndex:row];
    if (component == CIRCUITO)
        return [arraycircuito objectAtIndex:row];
    
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _tecnologia.text = [arraytecnologia objectAtIndex:[pickerView selectedRowInComponent:0]];
    _potencia.text = [arraypotencia objectAtIndex:[pickerView selectedRowInComponent:1]];
    _tipoPoste.text = [arraytipoPoste objectAtIndex:[pickerView selectedRowInComponent:2]];
    _tipoBrazo.text = [arraytipoBrazo objectAtIndex:[pickerView selectedRowInComponent:3]];
    _tipoLuminarias.text = [arraytipoLuminaria objectAtIndex:[pickerView selectedRowInComponent:4]];
    _circuito.text = [arraycircuito objectAtIndex:[pickerView selectedRowInComponent:5]];
    
    
//    NSString *tecnologiaSelected = [arraytecnologia objectAtIndex:[pickerView selectedRowInComponent:0]];
    NSString *potenciaSelected = [arraypotencia objectAtIndex:[pickerView selectedRowInComponent:1]];
//    NSString *tipoPoseSelected = [arraytipoPoste objectAtIndex:[pickerView selectedRowInComponent:2]];
//    NSString *tipoBrazoSelected = [arraytipoBrazo objectAtIndex:[pickerView selectedRowInComponent:3]];
    NSString *tipoLuminariasSelected = [arraytipoLuminaria objectAtIndex:[pickerView selectedRowInComponent:4]];
    NSString *circuitoSelected = [arraycircuito objectAtIndex:[pickerView selectedRowInComponent:5]];
    
    [_idLuminaria setText:[NSString stringWithFormat:@"%@-%@-%@", circuitoSelected, tipoLuminariasSelected, potenciaSelected]];
    
    
    
    codigoLuminaria = [[NSMutableArray alloc]init];
    
    NSString *lumlum = [[NSString alloc]initWithFormat:@"%@ - %@ - %@",circuitoSelected, tipoLuminariasSelected, potenciaSelected];
    [codigoLuminaria addObject:lumlum];
    
    
}

/*----------------------*/

- (void)updateTime
{
    if (auxlocation1 == nil)
    {
        auxlocation1 = [[Location alloc]init];
    }
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:@"hh:mm:ss"];
    auxlocation1.hora = [timeFormat stringFromDate:[NSDate date]];
    
    [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
    
    if (auxlocation2 == nil) {
        auxlocation2 = [[Location alloc]init];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyy-MM-dd"];
    auxlocation2.fecha = [dateFormat stringFromDate:[NSDate date]];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = _mapViewcenso.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.0025;
    mapRegion.span.longitudeDelta = 0.0025;
    
    
    [_mapViewcenso setRegion:mapRegion animated: YES];

}











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)actualizar:(id)sender {
    sqlite3_stmt *statement;
    
    if (sqlite3_open([dbPathString UTF8String], &OeCensoFinal)==SQLITE_OK) {
        [arrayOfLocation removeAllObjects];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM CENSOFINALOE"];
        const char* query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(OeCensoFinal, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *idluminaria = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 20)];
                NSString *identificador = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSString *tecnologia = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                NSString *potencia = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
                NSString *poste = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 14)];
                NSString *brazo = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 15)];
                NSString *luminaria = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 16)];
                NSString *circuito = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 17)];
                NSString *canales = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                
                Location *location = [[Location alloc]init];
                
                [location setIdentificador:identificador];
                [location setTecnologia:tecnologia];
                [location setPotencia:potencia];
                [location setTipoPoste:poste];
                [location setTipoBrazo:brazo];
                [location setTipoLuminaria:luminaria];
                [location setCircuito:circuito];
                [location setIdlum:idluminaria];
                [location setCanales:canales];
                
                [arrayOfLocation addObject:location];
                
                
                NSString *str = [[NSString alloc]initWithFormat:@"%@ - %@ - %@ - %@ - %@ - %@",tecnologia, potencia, poste, brazo, luminaria, circuito];
                [entries addObject:str];
            }
        }
    }
    [[self tableView]reloadData];
}



- (IBAction)registrar:(id)sender {
    
    
    if (auxlocation == nil)
    {
        auxlocation = [[Location alloc]init];
    }
    switch (_funciona.selectedSegmentIndex) {
        case 0:
            auxlocation.funciona = @"SI";
            break;
        case 1:
            auxlocation.funciona = @"NO";
            
        default:
            break;
    }
    char *error;
    if (sqlite3_open([dbPathString UTF8String], &OeCensoFinal)==SQLITE_OK) {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO CENSOFINALOE (FECHA,HORA,LATITUDE,LONGITUDE,CALLE,NUMERO,CIUDAD,RESERVA1,RESERVA2,CANALES,IDENTIFICADOR,TECNOLOGIA,POTENCIA,TIPOPOSTE,TIPOBRAZO,TIPOLUMINARIA,CIRCUITO,FUNCIONA,MEDIDOR,IDLUM) values ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')", [auxlocation2.fecha UTF8String], [auxlocation1.hora UTF8String], [self.latitude.text UTF8String], [self.longitude.text UTF8String], [self.calle.text UTF8String], [self.numero.text UTF8String], [self.ciudad.text UTF8String], [self.estado.text UTF8String], [self.pais.text UTF8String], [self.codigoPostal.text UTF8String],[self.ipadid.text UTF8String], [self.tecnologia.text UTF8String], [self.potencia.text UTF8String], [self.tipoPoste.text UTF8String], [self.tipoBrazo.text UTF8String], [self.tipoLuminarias.text UTF8String], [self.circuito.text UTF8String], [auxlocation.funciona UTF8String], [self.medidor.text UTF8String], [self.idLuminaria.text UTF8String]];
        
        const char *insert_stmt = [insertStmt UTF8String];
        SystemSoundID mySSID;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"swish" ofType:@"m4a"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: path], &mySSID);
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"OPTIMA ENERGIA" message:@"LUMINARIA CENSADA" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        if (sqlite3_exec(OeCensoFinal, insert_stmt, NULL, NULL, &error)==SQLITE_OK){
            AudioServicesPlaySystemSound(mySSID);
            [alert show];
            
            [[self tableView]setDelegate:self];
            [[self tableView]setDataSource:self];
            entries = [[NSMutableArray alloc]init];
            
            
            
            
            
            NSLog(@"Location Added");
            
           
            
            
            
            Location *location = [[Location alloc]init];
            [location setFecha:auxlocation2.fecha];
            [location setHora:auxlocation1.hora];
            [location setLatitude:self.latitude.text];
            [location setLongitude:self.longitude.text];
            [location setIdentificador:self.identificador.text];
            [location setTecnologia:self.tecnologia.text];
            [location setPotencia:self.potencia.text];
            [location setTipoPoste:self.tipoPoste.text];
            [location setTipoBrazo:self.tipoBrazo.text];
            [location setTipoLuminaria:self.tipoLuminarias.text];
            [location setCircuito:self.circuito.text];
            [location setCalle:self.calle.text];
            [location setNumero:self.numero.text];
            [location setCiduad:self.ciudad.text];
            [location setEstado:self.estado.text];
            [location setPais:self.pais.text];
            [location setCodigoPostal:self.codigoPostal.text];
            [location setFunciona:auxlocation.funciona];
            [location setMedidor:self.medidor.text];
            [location setIdlum:self.idLuminaria.text];
            
            
            
            
            
            
            
            [arrayOfLocation addObject:location];

            _medidor.text = @"";

            
            
        }
        sqlite3_close(OeCensoFinal);
    }
    NSString *strURL = [NSString stringWithFormat:@"http://201.116.139.38:81/luminarias.php?etiqueta=%@&sector=%@&colonia=%@&calle=%@&numero=%@&carriles=%@&tipoLuminaria=%@&potencia=%@&circuito=%@&medidor=%@&funciona=%@&tecnologia=%@&tipoPoste=%@&tipoBrazo=%@&latitud=%@&longitud=%@&ipadId=%@&fecha=%@&hora=%@&ciudad=%@",
                        
                        [_idLuminaria.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_pais.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_estado.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_calle.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_numero.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_codigoPostal.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_tipoLuminarias.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_potencia.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_circuito.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_medidor.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [auxlocation.funciona stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_tecnologia.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_tipoPoste.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_tipoBrazo.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_latitude.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_longitude.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_ipadid.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [auxlocation2.fecha stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [auxlocation1.hora stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_ciudad.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", strResult);
    
    NSString *strURL2 = [NSString stringWithFormat:@"http://201.116.139.38:83/luminarias.php?etiqueta=%@&sector=%@&colonia=%@&calle=%@&numero=%@&carriles=%@&tipoLuminaria=%@&potencia=%@&circuito=%@&medidor=%@&funciona=%@&tecnologia=%@&tipoPoste=%@&tipoBrazo=%@&latitud=%@&longitud=%@&ipadId=%@&fecha=%@&hora=%@&ciudad=%@",
                        
                        [_idLuminaria.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_pais.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_estado.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_calle.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_numero.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_codigoPostal.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_tipoLuminarias.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_potencia.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_circuito.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_medidor.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [auxlocation.funciona stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_tecnologia.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_tipoPoste.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_tipoBrazo.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_latitude.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_longitude.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_ipadid.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [auxlocation2.fecha stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [auxlocation1.hora stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_ciudad.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *dataURL2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL2]];
    
    NSString *strResult2 = [[NSString alloc] initWithData:dataURL2 encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", strResult2);
}

- (IBAction)email:(id)sender {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    dbPathString = [docPath stringByAppendingPathComponent:@"OeCensoFinal.db"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        
    }
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    mailController.mailComposeDelegate = self;
    [mailController setSubject:@"NUEVO CENSO LUMINARIAS"];
    NSArray *toRecipients = [NSArray arrayWithObjects:@"jpestana@optimaenergia.com", @"censoluminariasoptima@gmail.com", nil];
    [mailController setToRecipients:toRecipients];
    
    
    NSData *myData = [NSData dataWithContentsOfFile:dbPathString];
    [mailController addAttachmentData:myData mimeType:@"application/x-sqlite3" fileName:@"pruebabaseluminarias"];
    
    
    
    [self presentViewController:mailController animated:YES completion:nil];
    [mailController setMessageBody:@"Este es el censo de luminarias" isHTML:NO];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    
    NSString *currentlatitude = [[NSString alloc]initWithFormat:@"%.8f", newLocation.coordinate.latitude];
    _latitude.text = currentlatitude;
    NSString *currentlongitude = [[NSString alloc]initWithFormat:@"%.8f", newLocation.coordinate.longitude];
    _longitude.text = currentlongitude;
    
    
    
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
// _pais.text = placemark.country;
//_estado.text = placemark.administrativeArea;
            _ciudad.text = placemark.locality;
//_codigoPostal.text = placemark.postalCode;
            _calle.text = placemark.thoroughfare;
            _numero.text = placemark.subThoroughfare;
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}


- (IBAction)cambiarTipo:(id)sender {
    
    if (_mapViewcenso.mapType == MKMapTypeStandard)
        _mapViewcenso.mapType = MKMapTypeHybrid;
    else
        _mapViewcenso.mapType = MKMapTypeStandard;
}



- (IBAction)tomarFoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = YES;
    }

}
#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[self latitude]resignFirstResponder];
    [[self longitude]resignFirstResponder];
    [[self identificador]resignFirstResponder];
    [[self medidor]resignFirstResponder];
    [[self codigoPostal]resignFirstResponder];
    [[self pais]resignFirstResponder];
    [[self estado]resignFirstResponder];
}


- (IBAction)eliminar:(id)sender {
    [[self tableView]setEditing:!self.tableView.editing animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Location *p = [arrayOfLocation objectAtIndex:indexPath.row];
        [self deleteData:[NSString stringWithFormat:@"Delete from CENSOFINALOE where ID is '%s'", [p.identificador UTF8String]]];
        [arrayOfLocation removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    }

-(void)deleteData:(NSString *)deleteQuery{
    char *error;
    if (sqlite3_exec(OeCensoFinal, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK){
        NSLog(@"Person Deleted");
        
    }
}




- (IBAction)database:(id)sender {
     NSString *strURL = [NSString stringWithFormat:@"http://201.116.139.38:81/luminarias.php?etiqueta=%@&sector=%@&colonia=%@&calle=%@&numero=%@&carriles=%@&tipoLuminaria=%@&potencia=%@&circuito=%@&medidor=%@&funciona=%@&tecnologia=%@&tipoPoste=%@&tipoBrazo=%@&latitud=%@&longitud=%@&ipadId=%@&fecha=%@&hora=%@&ciudad=%@", 
                         
                         [_idLuminaria.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_pais.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_estado.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_calle.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_numero.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_codigoPostal.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_tipoLuminarias.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_potencia.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_circuito.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_medidor.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [auxlocation.funciona stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_tecnologia.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_tipoPoste.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_tipoBrazo.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_latitude.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_longitude.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_ipadid.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [auxlocation2.fecha stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [auxlocation1.hora stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [_ciudad.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", strResult);
}





@end
