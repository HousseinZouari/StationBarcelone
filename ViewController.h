//
//  ViewController.h
//  StationBarcelone
//
//  Created by cyrine on 18/10/2016.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "Station+CoreDataProperties.h"
#import "Stat.h"
#import "ShowPicturesController.h"
#import <MMProgressHUD.h>
#import "Reachability.h"


@interface ViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *stations_list;
@property (nonatomic,strong) IBOutlet MKMapView *mapview;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

