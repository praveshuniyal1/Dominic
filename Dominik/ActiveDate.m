//
//  ActiveDate.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "ActiveDate.h"
#import "ActiveDateCell.h"
#import "RecordingsVC.h"
#import "RecordingListVC.h"
#import "AppDelegate.h"
#import "RecordVC.h"
#import "AddSymptomes.h"
#import "FMDatabase.h"

@interface ActiveDate ()
{
    NSMutableArray *symptomArr;
    NSString *path;
    FMDatabase *database;
    NSMutableArray *selectArray;
    NSMutableArray *arr_symptomId;
    
    NSString *userId;
    NSString *selectDate;
    NSMutableDictionary *responceDic;
    NSMutableArray *responceArray;
    
    
    NSMutableArray *arrselect;
    NSInteger indexpath;
    
}

@end

@implementation ActiveDate

- (void)viewDidLoad
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    responceDic=[[NSMutableDictionary alloc]init];
    responceArray=[[NSMutableArray alloc]init];
    lblDate.text=selectDate;
    [self reloadTable];
    [self getCurrentWeather];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getCurrentWeather
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:KWeatherHourlyForcast parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *response = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
        responceArray=[response valueForKey:@"hourly_forecast"] ;
        [self loadWeatherDetail:responceArray];
        NSLog(@"Weather Info=%@",responceArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
            }];
    
    
}
-(void)loadWeatherDetail:(NSMutableArray *)weatherArr
{
    lblMorning.text=[[[weatherArr objectAtIndex:6]valueForKey:@"temp"]valueForKey:@"english"];
   
    imgMor.image = [UIImage imageWithData:
                                       [NSData dataWithContentsOfURL:
                                        [NSURL URLWithString: [[weatherArr objectAtIndex:6]valueForKey:@"icon_url"]]]];
    
    lblAfternoon.text=[[[weatherArr objectAtIndex:13]valueForKey:@"temp"]valueForKey:@"english"];
    imgAft.image = [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString: [[weatherArr objectAtIndex:13]valueForKey:@"icon_url"]]]];
    lblEveaning.text=[[[weatherArr objectAtIndex:18]valueForKey:@"temp"]valueForKey:@"english"];
    imgEve.image = [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString: [[weatherArr objectAtIndex:18]valueForKey:@"icon_url"]]]];
}
- (IBAction)logoutAction:(id)sender
{
    AddSymptomes *recordingView = [self.storyboard instantiateViewControllerWithIdentifier:@"AddSymptomes"];
    [self.navigationController pushViewController:recordingView animated:YES];
    // [KappDelgate logout];
}

- (IBAction)backbtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)recordingsAction:(id)sender
{
    RecordVC *recordingView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordVC"];
    [self.navigationController pushViewController:recordingView animated:YES];
}

- (IBAction)editAction:(id)sender
{
    
}

- (IBAction)dailyReminderAction:(id)sender {
}

- (IBAction)nextDate:(id)sender
{
    NSDate *currentDate=[[NSUserDefaults standardUserDefaults]valueForKey:@"dafault_selectDate"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:currentDate];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay];
    [components setMonth:theMonth];
    [components setYear:theYear];
    NSDate *thisDate = [gregorian dateFromComponents:components];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:currentDate options:0];
    [[NSUserDefaults standardUserDefaults]setObject:[self getDateFromString:nextDate] forKey:@"selectDate"];
     [[NSUserDefaults standardUserDefaults]setObject:nextDate forKey:@"dafault_selectDate"];
    lblDate.text=[self getDateFromString:nextDate];
    [self viewWillAppear:YES];
}

- (IBAction)previousDate:(id)sender
{
    NSDate *currentDate=[[NSUserDefaults standardUserDefaults]valueForKey:@"dafault_selectDate"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:currentDate];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay];
    [components setMonth:theMonth];
    [components setYear:theYear];
    NSDate *thisDate = [gregorian dateFromComponents:components];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-1];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:currentDate options:0];
    [[NSUserDefaults standardUserDefaults]setObject:[self getDateFromString:nextDate] forKey:@"selectDate"];
    [[NSUserDefaults standardUserDefaults]setObject:nextDate forKey:@"dafault_selectDate"];
     lblDate.text=[self getDateFromString:nextDate];
     [self viewWillAppear:YES];

}
-(NSString *)getDateFromString:(NSDate *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMM,yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:string];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return symptomArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"ActiveDateCell";
    ActiveDateCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[ActiveDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.lblSymptomes.text=[[symptomArr objectAtIndex:indexPath.row] valueForKey:@"symptomName"];
    [cell.btnSelect addTarget:self action:@selector(selectSymptom:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnSelect.tag=indexPath.row;
    
    if ([[[symptomArr valueForKey:@"isActive"] objectAtIndex:indexPath.row]isEqualToString:@"1"])
    {
        cell.btnSelect.selected=YES;
    }
    else{
        cell.btnSelect.selected=NO;
    }
    
    [cell.imageSymptom addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    cell.imageSymptom.tag=indexPath.row;
    
    
    [cell.btnSelect1 addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnSelect1.tag=indexPath.row;
    
    if ([[[symptomArr valueForKey:@"image"]objectAtIndex:indexPath.row]isKindOfClass:[NSNull class]])
    {
        UIImage *btnImage = [UIImage imageNamed:@"people-img"];
        [cell.imageSymptom setImage:btnImage forState:UIControlStateNormal];
    }
    else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
       NSString* str_offline=[self documentsPathForFileName:[[symptomArr valueForKey:@"image"]objectAtIndex:indexPath.row]];
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:[[symptomArr valueForKey:@"image"]objectAtIndex:indexPath.row]] lastPathComponent]]];
        
        [cell.imageSymptom setImage:[UIImage imageWithContentsOfFile:getImagePath] forState:UIControlStateNormal];
       
    }
    
   
    return cell;
}



- (IBAction)selectClicked:(UIButton*)sender
{
    NSLog(@"%ld",(long)sender.tag);
    arrselect = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++)
    {
        [arrselect addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    
    NSArray * arrImage = [[NSArray alloc] init];
    arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"location-pin"], [UIImage imageNamed:@"location-pin"], [UIImage imageNamed:@"location-pin"], [UIImage imageNamed:@"location-pin"], [UIImage imageNamed:@"location-pin"],  nil];
    if(dropDown == nil)
    {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arrselect :nil :@"down"];
        dropDown.delegate = self;
        [symptomTable addSubview:dropDown];
//        [symptomTable bringSubviewToFront:dropDown];
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    [self rel];
}


-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}






- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}




-(void)selectSymptom:(UIButton*)sender
{
    database = [FMDatabase databaseWithPath:path];
    [database open];
    if (sender.selected)
    {
        NSString *sql = [NSString stringWithFormat:@"UPDATE SymptomTable SET isActive='%@' WHERE id='%@' AND date='%@'",@"0",[arr_symptomId objectAtIndex:sender.tag],selectDate];
        BOOL success = [database executeUpdate:sql];
        if(success)
        {
            [self reloadTable];
        }
       // [symptomTable reloadData];
    }
    else
    {
        NSString *sql = [NSString stringWithFormat:@"UPDATE SymptomTable SET isActive='%@' WHERE id='%@' AND date='%@'",@"1",[arr_symptomId objectAtIndex:sender.tag],selectDate];
        BOOL success = [database executeUpdate:sql];
        if(success)
        {
            [self reloadTable];
        }
        //[symptomTable reloadData];
    }
   
    [database close];
    
}
-(void)reloadTable
{
    symptomArr=[[NSMutableArray alloc]init];
    selectArray=[[NSMutableArray alloc]init];
    arr_symptomId=[[NSMutableArray alloc]init];
    
    database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM AddSymptomTable WHERE user_id='%@'",userId];
    FMResultSet *results = [database executeQuery:sql];
    while ([results next])
    {
        [symptomArr addObject:[results resultDictionary]];
        [selectArray addObject:[[results resultDictionary]valueForKey:@"isActive"]];
        
    }
    [self addAction:symptomArr];
   // [symptomTable reloadData];
    [results close];
   
}

- (IBAction)addAction:(NSMutableArray*)array
{
    symptomArr=[[NSMutableArray alloc]init];
    
    database = [FMDatabase databaseWithPath:path];
    [database open];
    [database executeUpdate:@"create table SymptomTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,user_id text,date text,symptomName text,image text,isActive text)"];
    
    
    for (int i=0; i<array.count; i++)
    {
        
        NSString *searchString = [[array valueForKey:@"symptomName"] objectAtIndex:i];
        NSString *likeParameter = [NSString stringWithFormat:@"%%%@%%", searchString];
        NSString *sql = [NSString stringWithFormat:@"SELECT symptomName FROM SymptomTable WHERE symptomName ='%@' AND date ='%@'",searchString,selectDate];
        
        FMResultSet *results = [database executeQuery:sql, likeParameter];
        if([results next])
        {
            [results close];
        }
        else
        {
            NSString *query = [NSString stringWithFormat:@"insert into SymptomTable(user_id,symptomName,isActive,date,image) values ('%@','%@','%@','%@','%@')",
                               userId,[[array valueForKey:@"symptomName"] objectAtIndex:i],@"0",selectDate,[[array valueForKey:@"image"] objectAtIndex:i]];
            [database executeUpdate:query];

        }
        
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SymptomTable WHERE date ='%@'",selectDate];
    
    FMResultSet *results = [database executeQuery:sql];
    while ([results next])
    {
        [symptomArr addObject:[results resultDictionary]];
        [arr_symptomId addObject:[[results resultDictionary]valueForKey:@"id"]];
    }
    [results close];
    [database close];
    [symptomTable reloadData];
    
    
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
            
            
          NSString *  str_offline=[self documentsPathForFileName:strImagePath];
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:strImagePath] lastPathComponent]]];
            // UIImage *img=[UIImage imageWithContentsOfFile:getImagePath];
            
            
            [database open];
            NSString *query = [NSString stringWithFormat:@"UPDATE SymptomTable SET image='%@' where user_id='%@' AND symptomName='%@' AND date='%@'",
                               strImagePath,userId,[[symptomArr objectAtIndex:indexpath] valueForKey:@"symptomName"],selectDate];
            BOOL results = [database executeUpdate:query];
            
            if (results)
            {
                symptomArr=[NSMutableArray new];
                FMResultSet *results = [database executeQuery:@"SELECT * FROM SymptomTable"];
                while ([results next])
                {
                    [symptomArr addObject:[results resultDictionary]];
                }
                [symptomTable reloadData];
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








@end
