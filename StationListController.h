//
//  StationListController.h
//  StationBarcelone
//
//  Created by cyrine on 18/10/2016.
//
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "Stat.h"
#import "ShowPicturesController.h"
#import <MMProgressHUD.h>
@interface StationListController : UITableViewController

@property (strong, nonatomic) NSDictionary *stations_dic;
@property (strong, nonatomic) NSDictionary *nearstations_json;
@property (strong, nonatomic) NSDictionary *data_json;
@property (strong, nonatomic) NSDictionary *oneStation_json;
@property (strong, nonatomic) NSMutableArray *stations_list;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end
