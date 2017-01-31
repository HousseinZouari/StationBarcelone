//
//  TakePictureViewController.h
//  StationBarcelone
//
//  Created by cyrine on 18/10/2016.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Station+CoreDataProperties.m"
#import "Picture+CoreDataProperties.h"



@interface TakePictureViewController : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *picture;
- (IBAction)ajouterPhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nametxt;
@property (weak, nonatomic) NSString *stationName;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *ajouterBt;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end
