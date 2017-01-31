//
//  ShowPicturesController.m
//  StationBarcelone
//
//  Created by cyrine on 21/10/2016.
//
//

#import "ShowPicturesController.h"

@interface ShowPicturesController ()

@end

@implementation ShowPicturesController

    @synthesize stationImage;
    @synthesize stationFound;
    @synthesize appDelegate;
    @synthesize context;



- (void)viewDidLoad {
    
    [super viewDidLoad];
    appDelegate = [UIApplication sharedApplication].delegate;
    context = appDelegate.managedObjectContext;

    
    [MMProgressHUD showWithTitle:@"Loading..."];

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        //add UIBarButtonItem to navigation bar (add picture)
        UIBarButtonItem *myBarButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(buttonAction:)];
        self.navigationItem.rightBarButtonItems = @[myBarButton];
        
        
        
        
        //Get the station send in parameter from database
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

        NSEntityDescription *stationSeleted = [NSEntityDescription entityForName:@"Station" inManagedObjectContext:context];

        //find station by name
        NSPredicate *predicateStation =[NSPredicate predicateWithFormat:@"name=%@",stationImage];
        [fetchRequest setPredicate:predicateStation];
        [fetchRequest setEntity:stationSeleted];
        NSError *error;

        NSArray *fetchedStations = [context executeFetchRequest:fetchRequest error:&error];
        //Return the station selected
        stationFound = fetchedStations.firstObject;
        
        
        
        //*************************Return picturess of the selected station from DB**********************
        Picture *entityPicture = [NSEntityDescription entityForName:@"Picture" inManagedObjectContext:context];

        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"stat=%@",stationFound];

        [fetchRequest setPredicate:predicate];
        [fetchRequest setEntity:entityPicture];

        self.pictures =[[NSMutableArray alloc] init];
        self.pictures = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];


        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
                // Handle the error.
                NSLog(@"NO LISTS AVAILABLE IN REFRESH");
        }


        dispatch_async(dispatch_get_main_queue(), ^(void){
            [MMProgressHUD dismissWithSuccess:@"Completed!"];
            
            
        });
    });
//********************reload tableview *****************************************
[self.tableView reloadData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


//********************************Number of sections********************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}


//****************************Number of rows************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.pictures.count;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        
        NSString *namePicRemove =  (NSString *)[[self.pictures objectAtIndex:indexPath.row]valueForKey:@"name"];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *picSelected = [NSEntityDescription entityForName:@"Picture" inManagedObjectContext:context];
        
        //find station by name
        NSPredicate *predicatePic =[NSPredicate predicateWithFormat:@"name=%@",namePicRemove];
        [fetchRequest setPredicate:predicatePic];
        [fetchRequest setEntity:picSelected];
        NSError *error;
        
        NSArray *fetchedPics = [context executeFetchRequest:fetchRequest error:&error];
        //Return the station selected
        Picture* pictureFound = fetchedPics.firstObject;
        [context deleteObject:pictureFound];
        [self.pictures removeObjectAtIndex:indexPath.row];
        
        
        
        // [context deleteObject:favorisObj];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}


//********************************** Cell ******************************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"pic";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Picture *device = [self.pictures objectAtIndex:indexPath.row];
    
    
    UITextField *temp = (UITextField *)[self.view viewWithTag:11];
    UIImageView *temp2 = (UIImageView *)[self.view viewWithTag:10];
    UITextField *dateTxt = (UITextField *)[self.view viewWithTag:20];
    
    UIImage* image = [UIImage imageWithData:[device valueForKey:@"pic"]];
    
    
    dateTxt.text=[device valueForKey:@"date_p"];
    temp.text=[device valueForKey:@"name"];
    [temp2 setImage: image];
    
    
    return cell;
    
}


//*************************************

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
               sectionName = NSLocalizedString(@"My Pictures", @"mypictures");
    
    return sectionName;
}




//********************************  reload pictures of station after taking pic ********************
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *stationSeleted = [NSEntityDescription entityForName:@"Station" inManagedObjectContext:context];
    
    NSPredicate *predicateStation =[NSPredicate predicateWithFormat:@"name=%@",stationImage];
    
    [fetchRequest setPredicate:predicateStation];
    [fetchRequest setEntity:stationSeleted];
    NSError *error;
    NSArray *fetchedStations = [context executeFetchRequest:fetchRequest error:&error];
    
    
    //get the station selected
    stationFound = fetchedStations.firstObject;
    
    
    
    //get the pictures of the station from db
    Picture *entityPicture = [NSEntityDescription entityForName:@"Picture" inManagedObjectContext:context];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"stat=%@",stationFound];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entityPicture];
    self.pictures =[[NSMutableArray alloc] init];
    self.pictures = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        
    }
    
    //reload tableview
    [self.tableView reloadData];
    
    
}

//**************************** Send station name to the next controller *************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"sendStation"]) {
        
        TakePictureViewController *takePicController = segue.destinationViewController;
              takePicController.stationName=stationImage;
        
    }
    
    else if ([[segue identifier] isEqualToString:@"show_pic"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSString *namePicture = [[_pictures objectAtIndex:indexPath.row]  valueForKey:@"name"];
        PictureDetailController *destViewController = segue.destinationViewController;
        destViewController.pictureStation = namePicture;
       
        
    }
    
    
}


-(void)buttonAction:(id)sender
{
    [self performSegueWithIdentifier:@"sendStation" sender:sender];
}


@end
