//
//  AddSymptomes.m
//  Dominik
//
//  Created by amit varma on 04/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "AddSymptomes.h"
#import "AddSymptomesCell.h"
#import "FMDatabase.h"
#import "AppDelegate.h"

@interface AddSymptomes ()
{
    NSMutableArray *symptomArr;
    NSString *path;
    FMDatabase *database;
    NSString *userId;
    NSString *selectDate;
    NSInteger indexpath;
    NSString*  str_offline;
}
@property (nonatomic, strong) UIPopoverController *popOver;

@end

@implementation AddSymptomes

- (void)viewDidLoad
{
        [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    
    
    symptomArr=[[NSMutableArray alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    
    database = [FMDatabase databaseWithPath:path];
    [database open];
    
    
     NSString *sql = [NSString stringWithFormat:@"SELECT * FROM AddSymptomTable where user_id='%@'",userId];
    FMResultSet *results = [database executeQuery:sql];
    while ([results next])
    {
        [symptomArr addObject:[results resultDictionary]];
    }
    [symptomTable reloadData];
    [results close];
    symptomTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];


    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return symptomArr.count;    //count number of row from counting array hear cataGorry is An Array
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"AddSymptomesCell";
    AddSymptomesCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[AddSymptomesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.lblSymptomes.text=[[symptomArr valueForKey:@"symptomName"]objectAtIndex:indexPath.row];
    [cell.btnImage addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[[symptomArr valueForKey:@"image"]objectAtIndex:indexPath.row]isKindOfClass:[NSNull class]])
    {
        ////nothing to work
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        str_offline=[self documentsPathForFileName:[[symptomArr valueForKey:@"image"]objectAtIndex:indexPath.row]];
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:[[symptomArr valueForKey:@"image"]objectAtIndex:indexPath.row]] lastPathComponent]]];
        
        [cell.btnImage setImage:[UIImage imageWithContentsOfFile:getImagePath] forState:UIControlStateNormal];
    }
    
    cell.btnImage.tag=indexPath.row;

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
        
        
        NSString *sqlSymptom = [NSString stringWithFormat:@"DELETE FROM SymptomTable WHERE symptomName='%@' AND user_id='%@'",[[symptomArr valueForKey:@"symptomName"] objectAtIndex:indexPath.row],userId];
        BOOL resultssym = [database executeUpdate:sqlSymptom];
        
        if(resultssym)
        {
            // [symptomArr removeObjectAtIndex:indexPath.row];
        }
        if (symptomArr.count==0)
        {
            symptomArr=[NSMutableArray new];
        }
        
        
        
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM AddSymptomTable WHERE symptomName='%@' AND user_id='%@'",[[symptomArr valueForKey:@"symptomName"] objectAtIndex:indexPath.row],userId];
        BOOL results = [database executeUpdate:sql];
        
        if(results)
        {
            [symptomArr removeObjectAtIndex:indexPath.row];
        }
        if (symptomArr.count==0)
        {
            symptomArr=[NSMutableArray new];
        }
        
        [symptomTable reloadData];
        [database close];
        
        
        
       
       

        
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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


- (IBAction)addAction:(id)sender
{
    if (searchBar.text.length==0)
    {
        [KappDelgate showAlertView:nil with:@"Please fill symptom name"];
    }
    else{
        database = [FMDatabase databaseWithPath:path];
        [database open];
        [database executeUpdate:@"create table AddSymptomTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,user_id text,symptomName text,image text,isActive text,isHidden text)"];
        
        
        NSString *searchString = searchBar.text;
        NSString *likeParameter = [NSString stringWithFormat:@"%%%@%%", searchString];
        NSString *sql = [NSString stringWithFormat:@"SELECT symptomName FROM AddSymptomTable WHERE symptomName ='%@'",searchString];
        
        FMResultSet *results = [database executeQuery:sql, likeParameter];
        if ([results next])
        {
            [KappDelgate showAlertView:@"Message" with:@"this symptoms is allready added"];
            [results close];
        }
        else
        {
            NSString *query = [NSString stringWithFormat:@"insert into AddSymptomTable(user_id,symptomName,isActive,isHidden) values ('%@','%@','%@','%@')",
                               userId,searchBar.text,@"0",@"0"];
            [database executeUpdate:query];
            symptomArr =[NSMutableArray new];
            FMResultSet *results = [database executeQuery:@"SELECT symptomName FROM AddSymptomTable"];
            while ([results next])
            {
                [symptomArr addObject:[results resultDictionary]];
            }
            [database close];
            [results close];
            [symptomTable reloadData];
            
        }

    }

    
   
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
           // UIImage *img=[UIImage imageWithContentsOfFile:getImagePath];
            
           
            [database open];
            NSString *query = [NSString stringWithFormat:@"UPDATE AddSymptomTable SET image='%@' where user_id='%@' AND symptomName='%@'",
                               strImagePath,userId,[[symptomArr objectAtIndex:indexpath] valueForKey:@"symptomName"]];
            BOOL results = [database executeUpdate:query];
        
            if (results)
            {
                symptomArr=[NSMutableArray new];
                FMResultSet *results = [database executeQuery:@"SELECT * FROM AddSymptomTable"];
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

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}


- (IBAction)logOut:(id)sender {
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
