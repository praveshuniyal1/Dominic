//
//  LocationVC.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "LocationVC.h"
#import "LocationCell.h"
#import "AppDelegate.h"
#import "LocationManager.h"
#import "Constants.h"
#import "AFNetworking.h"
#import "FMDatabase.h"
#import "MapAnnotation.h"



@interface LocationVC ()
{
    NSMutableArray *locationArr;
    NSMutableArray *searchResults;
    BOOL searchdata;
    NSMutableDictionary *responceDic;
    NSMutableArray *responceArray;
    NSString *path;
    FMDatabase *database;
    NSString *userId;
    NSString *selectDate;
    NSString *latitute;
    NSString * longitude;
     NSInteger indexpath;
}

@end

@implementation LocationVC
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationArr=[[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
    
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation=YES;
    
    btnAction.userInteractionEnabled=NO;
    btnAction.alpha=0.5;
    
//    float spanX = 0.00725;
//    float spanY = 0.00725;
//    MKCoordinateRegion region;
//    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
//    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
//    region.span.latitudeDelta = spanX;
//    region.span.longitudeDelta = spanY;
//   
//    [self.mapView setRegion:region animated:YES];
//    [mapView setShowsUserLocation:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    locationArr=[NSMutableArray new];
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM locationTbl where user_id='%@' and date='%@'",userId,selectDate];
    FMResultSet *locationResults = [database executeQuery:sql];
    
    while([locationResults next])
    {
        [locationArr addObject:[locationResults resultDictionary]];
    }
    
    [tblLocation reloadData];
    [locationResults close];

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 5500, 5500);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutAction:(id)sender{
     [KappDelgate logout];
}

- (IBAction)backbtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark searchbar delegates:-

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 5)
    {
        tblSearch.hidden=NO;
        responceArray=[[NSMutableArray alloc]init];
        searchdata = YES;
        NSMutableString * googlePlaceUrl=[NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=50000&keyword=%@&key=%@",[[[NSUserDefaults standardUserDefaults]valueForKey:@"Latitude"] floatValue], [[[NSUserDefaults standardUserDefaults]valueForKey:@"Longitude"] floatValue],searchText,KgoogleApiKey];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:googlePlaceUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            NSDictionary *response = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
            responceArray=[response valueForKey:@"results"];
            [tblSearch reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
            
        }];

        
    }
    else
    {
       // tblSearch.hidden=YES;
        searchdata=NO;
        [tblLocation reloadData];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [search_Bar setShowsCancelButton:YES animated:YES];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self resignContectTable];
}
-(void)resignContectTable
{
    tblSearch.hidden=YES;
    searchdata=NO;
    [tblLocation reloadData];
    [search_Bar setText:@""];
    [search_Bar setShowsCancelButton:NO animated:YES];
    [search_Bar resignFirstResponder];
}



#pragma tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblLocation)
    {
        return locationArr.count;
    }
    else if (tableView==tblSearch)
    {
        return responceArray.count;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblLocation)
    {
        static NSString *MyIdentifier = @"LocationCell";
        LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[LocationCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
        }
        cell.lblLocation.text=[[locationArr valueForKey:@"locationName"] objectAtIndex:indexPath.row];
        
        
        
        [cell.lblImage addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        cell.lblImage.tag=indexPath.row;
        
        if ([[[locationArr valueForKey:@"image"]objectAtIndex:indexPath.row]isKindOfClass:[NSNull class]])
        {
            
        }
        else{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString*  str_offline=[self documentsPathForFileName:[[locationArr valueForKey:@"image"]objectAtIndex:indexPath.row]];
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:[[locationArr valueForKey:@"image"]objectAtIndex:indexPath.row]] lastPathComponent]]];
            
            [cell.lblImage setImage:[UIImage imageWithContentsOfFile:getImagePath] forState:UIControlStateNormal];
        }

        
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[[locationArr valueForKey:@"lat"] objectAtIndex:indexPath.row] doubleValue];
        coordinate.longitude = [[[locationArr valueForKey:@"long"] objectAtIndex:indexPath.row] doubleValue];
        MapAnnotation *annotation = [[MapAnnotation alloc] initWithName:[[locationArr valueForKey:@"locationName"] objectAtIndex:indexPath.row] address:@"" coordinate:coordinate] ;
        self.mapView.delegate = self;
        [self.mapView addAnnotation:annotation];
        
        return cell;
 
    }
    else if (tableView==tblSearch)
    {
        static NSString *MyIdentifier = @"Location";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
        }
        cell.textLabel.text=[[responceArray valueForKey:@"vicinity"] objectAtIndex:indexPath.row];
        return cell;

    }
    return nil;
 }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==tblSearch)
    {
        
        btnAction.tag=indexPath.row;
        search_Bar.text=[[responceArray valueForKey:@"vicinity"] objectAtIndex:indexPath.row];
        btnAction.userInteractionEnabled=YES;
        btnAction.alpha=1.0;
        tblSearch.hidden=YES;
        
        
    }
    else if(tableView==tblLocation)
    {
        
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        
        [database open];
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM locationTbl WHERE date='%@' AND locationName='%@'",selectDate,[[locationArr valueForKey:@"locationName"] objectAtIndex:indexPath.row]];
        BOOL results = [database executeUpdate:sql];
        
        if(results)
        {
            [locationArr removeObjectAtIndex:indexPath.row];
        }
        if (locationArr.count==0)
        {
            locationArr=[NSMutableArray new];
        }
        [database close];
        [tblLocation reloadData];
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"MapAnnotation";
    if ([annotation isKindOfClass:[MapAnnotation class]])
    {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"location-pin"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    else if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"slider-toggle-btn-red"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}


- (IBAction)AddAction:(UIButton*)sender
{
    
    locationArr=[NSMutableArray new];
    database = [FMDatabase databaseWithPath:path];
    [database open];
    [database executeUpdate:@"create table locationTbl(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,user_id text,locationName text,date text,image text,lat float,long float)"];
    
    
    NSString *searchString = [[searchResults valueForKey:@"name"] objectAtIndex:sender.tag];
    NSString *likeParameter = [NSString stringWithFormat:@"%%%@%%", searchString];
    NSString *sql = [NSString stringWithFormat:@"SELECT locationName FROM locationTbl WHERE locationName ='%@'",searchString];
    
    FMResultSet *results = [database executeQuery:sql, likeParameter];
    if ([results next])
    {
        [KappDelgate showAlertView:@"Message" with:@"this location is allready added"];
        [results close];
    }
    else
    {
        
        latitute=[[[[responceArray valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] objectAtIndex:sender.tag];
        longitude=[[[[responceArray valueForKey:@"geometry"] valueForKey:@"location"]valueForKey:@"lng"] objectAtIndex:sender.tag];
        
        NSString *query = [NSString stringWithFormat:@"insert into locationTbl(user_id,locationName,date,lat,long) values ('%@','%@','%@','%f','%f')",
                           userId,[[responceArray valueForKey:@"vicinity"] objectAtIndex:sender.tag],[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"],[latitute floatValue],[longitude floatValue]];
        [database executeUpdate:query];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM locationTbl where user_id='%@' and date='%@'",userId,selectDate];
        FMResultSet *results = [database executeQuery:sql];
        
        while ([results next])
        {
            [locationArr addObject:[results resultDictionary]];
        }
        [database close];
        [results close];
        [tblLocation reloadData];
    }
    [self resignContectTable];

}


-(void)selectImage:(UIButton*)sender
{
    indexpath=sender.tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Face for Perform Dance step"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Select from Library", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}




#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int i = buttonIndex;
    switch(i)
    {
        case 0:
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{}];
        }
            break;
        case 1:
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{}];
        }
        default:
            // Do Nothing.........
            break;
    }
}
#pragma mark -
#pragma - mark Selecting Image from Camera and Library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    UIImage *selectedImage;
    NSURL * mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
    
    if (mediaUrl == nil) {
        
        selectedImage = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        if (selectedImage == nil) {
            
            selectedImage= (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
            
            
            CGRect rect = CGRectMake(0,0,200,200);
            UIGraphicsBeginImageContext( rect.size );
            [selectedImage drawInRect:rect];
            UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSData *profile_image_data = UIImagePNGRepresentation(picture1);
            
            ///////////////////////////////////////Store image in document directory
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
            NSString*str_date=[format stringFromDate:[NSDate date]];
            NSString *strImagePath=[NSString stringWithFormat:@"%@.png",str_date];
            
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            NSString *filePath = [documentsPath stringByAppendingPathComponent:strImagePath];
            [profile_image_data writeToFile:filePath atomically:YES];
            
            
            NSString* str_offline=[self documentsPathForFileName:strImagePath];
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:strImagePath] lastPathComponent]]];
            UIImage *img=[UIImage imageWithContentsOfFile:getImagePath];
            
            
            [database open];
            NSString *query = [NSString stringWithFormat:@"UPDATE locationTbl SET image='%@' where user_id='%@' AND date='%@' AND locationName='%@'",
                               strImagePath,userId,selectDate,[[locationArr objectAtIndex:indexpath] valueForKey:@"locationName"]];
            BOOL results = [database executeUpdate:query];
            
            if (results)
            {
                locationArr=[NSMutableArray new];
                FMResultSet *results = [database executeQuery:@"SELECT * FROM locationTbl"];
                while ([results next])
                {
                    [locationArr addObject:[results resultDictionary]];
                }
                [tblLocation reloadData];
                [results close];
                
            }
            
            NSLog(@"Original image picked.");
            
        }
        else {
            
            NSLog(@"Edited image picked.");
            
        }
        
    }
    
    [picker dismissModalViewControllerAnimated:YES];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}



@end
