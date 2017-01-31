//
//  PictureDetailController.m
//  StationBarcelone
//
//  Created by cyrine on 21/10/2016.
//
//

#import "PictureDetailController.h"

@interface PictureDetailController ()

@end

@implementation PictureDetailController

@synthesize pictureStation;
@synthesize backgroundImage;
@synthesize context;
@synthesize appDelegate;
Picture *pictureFound1;


//******************************* show the picture selected ********************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [UIApplication sharedApplication].delegate;
    context = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *stationSeleted = [NSEntityDescription entityForName:@"Picture" inManagedObjectContext:context];
   
    NSPredicate *predicateStation =[NSPredicate predicateWithFormat:@"name=%@",pictureStation];
    
    [fetchRequest setPredicate:predicateStation];
    [fetchRequest setEntity:stationSeleted];
    NSError *error;
    NSArray *fetchedStations = [context executeFetchRequest:fetchRequest error:&error];
    //get the station selected
     pictureFound1 = fetchedStations.firstObject;
    
    // put the picture in the UIImageView
    UIImage* image = [UIImage imageWithData:[pictureFound1 valueForKey:@"pic"]];
    [backgroundImage setImage: image];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}



// ********************************* share the picture on facebook ****************************
- (IBAction)FbButton:(id)sender {
    
    SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [composeController setInitialText:[pictureFound1 valueForKey:@"date_p"]];
    [composeController addImage:backgroundImage.image];
    
    
    [self presentViewController:composeController animated:YES completion:nil];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
          
        } else  {
           
        }
        
       
    };
    composeController.completionHandler =myBlock;
    
    
    
    
}


// ******************************** share the picture on tweeter **************************************
- (IBAction)TwitterButton:(id)sender {
    SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [composeController setInitialText:[pictureFound1 valueForKey:@"date_p"]];
    [composeController addImage:backgroundImage.image];
   
    
    [self presentViewController:composeController animated:YES completion:nil];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
                   } else  {
           
        }
        
      
    };
    composeController.completionHandler =myBlock;
}



@end
