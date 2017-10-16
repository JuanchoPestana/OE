//
//  MainViewController.h
//  OptimaEnergia
//
//  Created by Juan Pestana on 4/3/13.
//  Copyright (c) 2013 Juan Pestana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Location.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define TECNOLOGIA 0
#define POTENCIA 1
#define TIPOPOSTE 2
#define TIPOBRAZO 3
#define TIPOLUMINARIA 4
#define CIRCUITO 5

@interface MainViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>{
    
    IBOutlet UIPickerView *pickerluminarias;
    
    NSMutableArray *arraypotencia;
    NSMutableArray *arraytipoPoste;
    NSMutableArray *arraytipoBrazo;
    NSMutableArray *arraytipoLuminaria;
    NSMutableArray *arraycircuito;
    NSMutableArray *arraytecnologia;
    
    NSMutableArray *searchResults;
    
    Location *auxlocation;
    Location *auxlocation1;
    Location *auxlocation2;
    
    Location *identificadorfinal;
    
}

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@property BOOL newMedia;

@property (strong, nonatomic) IBOutlet UITextField *identificador;
@property (strong, nonatomic) IBOutlet UITextField *latitude;
@property (strong, nonatomic) IBOutlet UITextField *longitude;


@property (strong, nonatomic) IBOutlet UITextField *pais;
@property (strong, nonatomic) IBOutlet UITextField *ciudad;
@property (strong, nonatomic) IBOutlet UITextField *estado;
@property (strong, nonatomic) IBOutlet UITextField *codigoPostal;
@property (strong, nonatomic) IBOutlet UITextField *calle;
@property (strong, nonatomic) IBOutlet UITextField *numero;



@property (strong, nonatomic) IBOutlet UISegmentedControl *funciona;
@property (strong, nonatomic) IBOutlet UITextField *potencia;
@property (strong, nonatomic) IBOutlet UITextField *tipoPoste;
@property (strong, nonatomic) IBOutlet UITextField *tipoBrazo;
@property (strong, nonatomic) IBOutlet UITextField *tipoLuminarias;
@property (strong, nonatomic) IBOutlet UITextField *circuito;
@property (strong, nonatomic) IBOutlet UITextField *tecnologia;
@property (strong, nonatomic) IBOutlet UITextField *medidor;

@property (strong, nonatomic) IBOutlet MKMapView *mapViewcenso;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerluminarias;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *idLuminaria;


- (IBAction)tomarFoto:(id)sender;
- (IBAction)actualizar:(id)sender;
- (IBAction)registrar:(id)sender;
- (IBAction)email:(id)sender;
- (IBAction)cambiarTipo:(id)sender;

- (IBAction)eliminar:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *ipadid;

@property(nonatomic, retain) NSMutableArray *entries;
@property(nonatomic, retain) NSMutableArray *codigoLuminaria;

- (IBAction)database:(id)sender;


@end
