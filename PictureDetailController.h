//
//  PictureDetailController.h
//  StationBarcelone
//
//  Created by cyrine on 21/10/2016.
//
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "AppDelegate.h"
#import "Picture+CoreDataProperties.h"


@interface PictureDetailController : UIViewController
- (IBAction)FbButton:(id)sender;
- (IBAction)TwitterButton:(id)sender;
- (IBAction)MailButton:(id)sender;
@property (weak) NSString* pictureStation;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end
