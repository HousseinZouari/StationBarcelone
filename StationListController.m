//
//  StationListController.m
//  StationBarcelone
//
//  Created by cyrine on 18/10/2016.
//
//

#import "StationListController.h"

@interface StationListController ()

@end

@implementation StationListController


    @synthesize appDelegate;
    @synthesize context;
    @synthesize stations_dic;
    @synthesize data_json;
    @synthesize nearstations_json;
    @synthesize stations_list;
    @synthesize oneStation_json;
    static NSString  *url=@"http://barcelonaapi.marcpous.com/bus/nearstation/latlon/41.3985182/2.1917991/1.json";



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MMProgressHUD showWithTitle:@"Loading..."];
    stations_list = [[NSMutableArray alloc] init];
     dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    NSURL *url1=[NSURL URLWithString: url];
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    
    [manager GET:url1.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.stations_dic=(NSDictionary*)responseObject;
        data_json=[stations_dic objectForKey:@"data"];
        nearstations_json=[data_json objectForKey:@"nearstations"];
        NSArray *fetchedStations;
        
        // call the function to load stations
        [self ChargerStations:nearstations_json];
        
        appDelegate = [UIApplication sharedApplication].delegate;
        context = appDelegate.managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        //insert into database
        for(Stat *s in stations_list){
            
            // search if the station has already been saved in the db
            NSEntityDescription *stationSeleted = [NSEntityDescription entityForName:@"Station" inManagedObjectContext:context];
            
            NSPredicate *predicateStation =[NSPredicate predicateWithFormat:@"name=%@",s.streetName];
            [fetchRequest setPredicate:predicateStation];
            [fetchRequest setEntity:stationSeleted];
            NSError *error;
            
            fetchedStations = [context executeFetchRequest:fetchRequest error:&error];
            
            
            //if the station doesn't exist in database add it
            if(fetchedStations.count==0){
                Station  *station1 = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:context];
                [station1 setValue:s.streetName forKey:@"name"];
                
            }
 
        }
        
        // reload tableview with the stations
        [self.tableView reloadData];
        
        
    }
         failure:^(NSURLSessionTask *operation,NSError *error){
        NSLog(@ "%@",error);
    }];
         
         dispatch_async(dispatch_get_main_queue(), ^(void){
             [MMProgressHUD dismissWithSuccess:@"Completed!"];
             
             
         });
     });
    
}


//**********************************  parsing the list of stations *********************
- (void) ChargerStations:(NSArray*)res{
    stations_list = [[NSMutableArray alloc] init];
    
    
    for(int i=0; i<[nearstations_json count];i++)
    {
        oneStation_json= [res objectAtIndex:i];
        
        Stat *station = [[Stat alloc] init];
        station.streetName=[oneStation_json objectForKey:@"street_name"];
        station.city=[oneStation_json objectForKey:@"city"];
       
        [stations_list addObject:station];
        
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}


//******************************   Number of rows    ******************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [stations_list count];
}


//****************************** the cell of tableview ******************************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *simpleTableIdentifier = @"StationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *streetName=[self.stations_list[indexPath.row] streetName];
    
    UILabel *lblTitle = (UILabel *)[tableView viewWithTag:10];
    lblTitle.text = streetName;
    UIImageView *img = (UIImageView *)[tableView viewWithTag:100];
    img.image = [UIImage imageNamed:@"barcelone"];
    img.layer.cornerRadius = img.frame.size.width / 2;
    img.clipsToBounds = YES;
    
    
    UILabel *lblBuses = (UILabel *)[tableView viewWithTag:60];
    lblBuses.text = [self.stations_list[indexPath.row] city];
    
    UIImageView *img1 = (UIImageView *)[tableView viewWithTag:120];
    img1.image = [UIImage imageNamed:@"image"];
    
    //**************************   adding animation  to cell   ***************************
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];

    
    return cell;
}





//*********************************    the number of sections in the tableview   *********************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


//**********************   send the name of the station to the next viewcontroller  *****************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"show_detail"]) {
        
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:sender];
        Stat *selectedStation = [stations_list objectAtIndex:indexPath.row];
         ShowPicturesController *destViewController = segue.destinationViewController;
        destViewController.stationImage = selectedStation.streetName;
        destViewController.hidesBottomBarWhenPushed = YES;
        
        
    }
}

@end
