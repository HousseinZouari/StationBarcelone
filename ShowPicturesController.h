//
//  ShowPicturesController.h
//  StationBarcelone
//
//  Created by cyrine on 21/10/2016.
//
//

#import <UIKit/UIKit.h>
#import "Stat.h"
#import "Picture+CoreDataProperties.h"
#import "Station+CoreDataProperties.m"
#import "TakePictureViewController.h"
#import "PictureDetailController.h"
#import <MMProgressHUD.h>
@interface ShowPicturesController : UITableViewController

@property (strong) NSMutableArray *pictures;
@property (weak) NSString* stationImage;
@property (weak) Station* stationFound;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *context;

- (IBAction)addPicture:(id)sender;

@end
