//
//  TakePictureViewController.m
//  StationBarcelone
//
//  Created by cyrine on 18/10/2016.
//
//

#import "TakePictureViewController.h"

@interface TakePictureViewController ()

@end

@implementation TakePictureViewController


    UIImagePickerController *picker;
    UIImage *image;
    Picture *pictureFound;
    NSInteger *i=0;
    @synthesize stationName;
    @synthesize appDelegate;
    @synthesize context;
    @synthesize picture;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [UIApplication sharedApplication].delegate;
    context = appDelegate.managedObjectContext;
}



- (void) viewWillDisappear:(BOOL)animated {
    //i is used to know which instruction to execute ajouterPhoto
    i=0;
   }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



//********************************* Click button addPhoto******************************
- (IBAction)ajouterPhoto:(id)sender {
    
    // take a picture
    if(i==0){
        
        picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    
    
    //Save picture in database
    if(i==1){
        
        // if namePicture Textfield is empty
        if([self.nametxt.text length]==0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Renommer la photo " message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
        
        
        else{
            // test if there is any picture with the same name
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            
            NSEntityDescription *PictureSeleted = [NSEntityDescription entityForName:@"Picture" inManagedObjectContext:context];
            
            NSPredicate *predicatePicture =[NSPredicate predicateWithFormat:@"name=%@",self.nametxt.text];
            
            [fetchRequest setPredicate:predicatePicture];
            [fetchRequest setEntity:PictureSeleted];
            NSError *error;
            NSArray *fetchedPics = [context executeFetchRequest:fetchRequest error:&error];
            
            if(fetchedPics.count>0){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Renommer la photo " message:@"nom existe déja" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
            
            
            
            else{
           //saving picture in database
        NSEntityDescription *stationSeleted = [NSEntityDescription entityForName:@"Station" inManagedObjectContext:context];
        fetchRequest = [[NSFetchRequest alloc] init];
        NSPredicate *predicateStation =[NSPredicate predicateWithFormat:@"name=%@",stationName];
       
        [fetchRequest setPredicate:predicateStation];
        [fetchRequest setEntity:stationSeleted];
        NSError *error1;
        NSArray *fetchedStations;
        fetchedStations = [context executeFetchRequest:fetchRequest error:&error1];
        
        Picture  *pic = [NSEntityDescription insertNewObjectForEntityForName:@"Picture" inManagedObjectContext:context];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *stringFromDate = [dateFormatter stringFromDate:[NSDate date]];
        
        
        [pic setValue:self.nametxt.text forKey:@"name"];
        [pic setValue: stringFromDate forKey:@"date_p"];
        [pic setValue:UIImagePNGRepresentation(self.picture.image) forKey:@"pic"];
        
        //add the relationship between the picture and station
        NSMutableSet * mSet = [[NSMutableSet alloc]init];
        [mSet addObject:fetchedStations.firstObject];
        pic.stat=fetchedStations.firstObject;
        i=0;
        [self.navigationController popViewControllerAnimated:YES];
       }
       }
    }
    
    
}

//************************************* after taking the picture ********************************
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    image=[info objectForKey: @"UIImagePickerControllerOriginalImage"];
    [self.picture setImage:image];
    
    //change the title of buton _ajouterBt to enregistrer to save the picture
    i=1;
    [_ajouterBt setTitle:@"Enregistrer" forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:NULL];
}



//************************** Override the phone's keyboard***********************************

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.nametxt) {
        [theTextField resignFirstResponder];
    }
    
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
