//
//  FoodDrinkVC.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "FoodDrinkVC.h"
#import "FoodDrinkCell.h"
#import "AppDelegate.h"
#import "FMDatabase.h"

@interface FoodDrinkVC ()
{
    NSMutableArray *foodArr;
    NSString *path;
    FMDatabase *database;
    NSString *userId;
    NSString *selectDate;
    NSString *str_offline;
    NSInteger indexpath;
    

}

@property (nonatomic, strong) UIPopoverController *popOver;

@end

@implementation FoodDrinkVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    foodArr=[NSMutableArray new];
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM AddFoodTbl where user_id='%@' and date='%@'",userId,selectDate];
    FMResultSet *foodResults = [database executeQuery:sql];
    
    while([foodResults next])
    {
        [foodArr addObject:[foodResults resultDictionary]];
    }
    
    [foodTable reloadData];
    [foodResults close];
    
     foodTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)logoutAction:(id)sender{
     [KappDelgate logout];
}

- (IBAction)backbtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return foodArr.count;    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"FoodDrink";
    FoodDrinkCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[FoodDrinkCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:MyIdentifier];
    }
    cell.lblFood.text=[[foodArr valueForKey:@"foodName"] objectAtIndex:indexPath.row];
    [cell.foodImage addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    cell.foodImage.tag=indexPath.row;
    
    if ([[[foodArr valueForKey:@"image"]objectAtIndex:indexPath.row]isKindOfClass:[NSNull class]])
    {
        
    }
    else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        str_offline=[self documentsPathForFileName:[[foodArr valueForKey:@"image"]objectAtIndex:indexPath.row]];
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:[[foodArr valueForKey:@"image"]objectAtIndex:indexPath.row]] lastPathComponent]]];
        
        [cell.foodImage setImage:[UIImage imageWithContentsOfFile:getImagePath] forState:UIControlStateNormal];
    }

    
    return cell;
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
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM AddFoodTbl WHERE date='%@' AND foodName='%@'",selectDate,[[foodArr valueForKey:@"foodName"] objectAtIndex:indexPath.row]];
        BOOL results = [database executeUpdate:sql];
        
        if(results)
        {
            [foodArr removeObjectAtIndex:indexPath.row];
        }
        if (foodArr.count==0)
        {
            foodArr=[NSMutableArray new];
        }
        [database close];
        [foodTable reloadData];

       
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



//////////////////Extra work


- (IBAction)addAction:(id)sender
{
    if (searchBar.text.length==0)
    {
        [KappDelgate showAlertView:nil with:@"Please fill Food and Drink Name"];
    }
    else{
        foodArr=[NSMutableArray new];
        database = [FMDatabase databaseWithPath:path];
        [database open];
        [database executeUpdate:@"create table AddFoodTbl(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,user_id text,foodName text,date text,image text)"];
        
        
        NSString *searchString = searchBar.text;
        NSString *likeParameter = [NSString stringWithFormat:@"%%%@%%", searchString];
        NSString *sql = [NSString stringWithFormat:@"SELECT foodName FROM AddFoodTbl WHERE foodName ='%@' and date='%@'",searchString,selectDate];
        
        FMResultSet *results = [database executeQuery:sql, likeParameter];
        if ([results next])
        {
            [KappDelgate showAlertView:@"Message" with:@"this food is allready added"];
            [results close];
        }
        else
        {
            NSString *query = [NSString stringWithFormat:@"insert into AddFoodTbl(user_id,foodName,date) values ('%@','%@','%@')",
                               userId,searchBar.text,[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"]];
            [database executeUpdate:query];
            
            NSString *sql = [NSString stringWithFormat:@"SELECT foodName FROM AddFoodTbl where user_id='%@' and date='%@'",userId,selectDate];
            FMResultSet *results = [database executeQuery:sql];
            
            while ([results next])
            {
                [foodArr addObject:[results resultDictionary]];
            }
            [database close];
            [results close];
            [foodTable reloadData];
            
            
        }

    }
    
    
    
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
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //your code
                    
                    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
                    [popover presentPopoverFromRect:CGRectMake(450.0f, 825.0f, 10.0f, 10.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    self.popOver = popover;
                }];
                
                
                
            } else
            {
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:^{}];
            }

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
    
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    
    
    
    
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
            
            
            str_offline=[self documentsPathForFileName:strImagePath];
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:strImagePath] lastPathComponent]]];
            UIImage *img=[UIImage imageWithContentsOfFile:getImagePath];
            
            
            [database open];
            NSString *query = [NSString stringWithFormat:@"UPDATE AddFoodTbl SET image='%@' where user_id='%@' AND date='%@' AND foodName='%@'",
                               strImagePath,userId,selectDate,[[foodArr objectAtIndex:indexpath] valueForKey:@"foodName"]];
            BOOL results = [database executeUpdate:query];
            
            if (results)
            {
                foodArr=[NSMutableArray new];
                FMResultSet *results = [database executeQuery:@"SELECT * FROM AddFoodTbl"];
                while ([results next])
                {
                    [foodArr addObject:[results resultDictionary]];
                }
                [foodTable reloadData];
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
