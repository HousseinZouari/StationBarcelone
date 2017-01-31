//
//  ViewController.m
//  StationBarcelone
//
//  Created by cyrine on 18/10/2016.
//
//

#import "ViewController.h"

@interface ViewController ()

@end


@implementation ViewController
    
    @synthesize appDelegate;
    @synthesize context;
    @synthesize stations_list;

    CLLocationManager *locationManager;
    NSString *streetName;

    #define METERS_PER_MILE 609.344


//**************************Show the map********************************
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //initialisation of appDelegate and context
    appDelegate = [UIApplication sharedApplication].delegate;
    context = appDelegate.managedObjectContext;
    
    
    //testing the internet connection
    if ([self connected]) {
        
      [MMProgressHUD showWithTitle:@"Loading..."];
        
        
      stations_list = [[NSMutableArray alloc] init];
        
        
        
      dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
          
          // add UIBarButtonItem to the navigationbar
            UIImage*  image = [UIImage imageNamed:@"user"];
            UIBarButtonItem *myBarButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(buttonAction:)];
            self.navigationItem.rightBarButtonItems = @[myBarButton];
    
    
          self.mapview.delegate = self;
          
          
          // Show the user current location
            locationManager = [[CLLocationManager alloc] init];
          _mapview.showsUserLocation = true;
          self.mapview.mapType = MKMapTypeStandard;
          self.mapview.showsUserLocation = YES;
          [self.mapview addAnnotations:[self createAnnotation]];
    
          
           //*************insert into database*********
  
          NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
          NSArray *fetchedStations;
    
    for(Stat *s in stations_list){
       
        
        NSEntityDescription *stationSeleted = [NSEntityDescription entityForName:@"Station" inManagedObjectContext:context];
        
        NSPredicate *predicateStation =[NSPredicate predicateWithFormat:@"name=%@",s.streetName];
        [fetchRequest setPredicate:predicateStation];
        [fetchRequest setEntity:stationSeleted];
    
        
        NSError *error;
        fetchedStations = [context executeFetchRequest:fetchRequest error:&error];
        
        
        //if name of station doesn't exist in db, add it
        if(fetchedStations.count==0){
            Station  *station1 = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:context];
            [station1 setValue:s.streetName forKey:@"name"];
            
            
        }
        
        
        
    }
   
   
          [self zoomToLocation];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [MMProgressHUD dismissWithSuccess:@"Completed!"];
        
        
    });
    });
        
        
        
        
        
        
    }
    //if there is  no internet connection
    
    else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Pas de connexion Internet" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


//*********************************** method for testing internet connection *****************************
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


//********************************* Parsing all the stations and create annotation ***********************
- (NSMutableArray *)createAnnotation
{
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    NSError *error;
    
    NSString *url_string = [NSString stringWithFormat: @"http://barcelonaapi.marcpous.com/bus/nearstation/latlon/41.3985182/2.1917991/1.json"];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary *locations=[[json objectForKey:@"data"]objectForKey:@"nearstations"];
    
    
    for (NSDictionary *row in locations) {
        
        NSNumber *latitude = [row objectForKey:@"lat"];
        NSNumber *longitude = [row objectForKey:@"lon"];
        NSString *title = [row objectForKey:@"street_name"];
        
        
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
        myAnnotation.coordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
        myAnnotation.title = title;
        
        myAnnotation.subtitle =[row objectForKey:@"buses"];
        
        
        [annotations addObject:myAnnotation];
        
        Stat *station = [[Stat alloc] init];
        
        station.streetName=title;
        [stations_list addObject:station];
        
    }
    return annotations;
    
}



-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    
    MKPointAnnotation *annotation1 = view.annotation;
    streetName = annotation1.title;
   
   
    [self performSegueWithIdentifier:@"SegueName" sender:self];
}



//*********************   go the ShowPicturesController  *********************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"SegueName"])
    {
        
        Stat *station = [[Stat alloc] init];
       
        station.streetName=streetName;
        
        ShowPicturesController *destViewController = segue.destinationViewController;
        destViewController.stationImage = station.streetName;
        destViewController.hidesBottomBarWhenPushed = YES;

        
        
        
    }
}


//************************************ create  the pinviews   ******************************************
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"pin"];
            pinView.calloutOffset = CGPointMake(0, 32);
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
            
            // Add an image to the left callout.
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]];
            pinView.leftCalloutAccessoryView = iconView;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}



//*************************    The action of UIBarButtonItem       *************************************
-(void)buttonAction:(id)sender
{
    [locationManager requestAlwaysAuthorization];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = _mapview.userLocation.coordinate.latitude;
    zoomLocation.longitude= _mapview.userLocation.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 7.5*METERS_PER_MILE,7.5*METERS_PER_MILE);
    [self.mapview setRegion:viewRegion animated:YES];
    
    [self.mapview regionThatFits:viewRegion];
    
}


//*************************************   zoom in the map      ************************************
- (void)zoomToLocation
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 41.3985182;
    zoomLocation.longitude= 2.1917991;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, METERS_PER_MILE,METERS_PER_MILE);
    
    
    [self.mapview setRegion:viewRegion animated:YES];
    [self.mapview regionThatFits:viewRegion];
}


//********************************  when the viewcontroller appears      ******************
   
- (void)viewWillAppear:(BOOL)animated
    {
        // add UIBarButtonItem to the navigationbar
        UIImage*  image = [UIImage imageNamed:@"user"];
        UIBarButtonItem *myBarButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(buttonAction:)];
        self.navigationItem.rightBarButtonItems = @[myBarButton];
    }

@end
