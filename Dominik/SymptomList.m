//
//  SymptomList.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "SymptomList.h"
#import "SymptomListCell.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "CollectionView.h"
#import "TableViewCell.h"
#import "ControlVC.h"



@interface SymptomList ()
{
    NSString *path;
    FMDatabase *database;
    NSMutableArray *symptomArr;
    NSString *userId;
    NSString *selectDate;
    NSInteger indexpath;
    
}

@property (nonatomic, strong) UIPopoverController *popOver;

@end

@implementation SymptomList

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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutAction:(id)sender{
     [KappDelgate logout];
}

- (IBAction)backbtnAction:(id)sender
{
   //    [self.navigationController popViewControllerAnimated:YES];
    [KappDelgate tabbar];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==symptomTable)
    {
        return symptomArr.count;
    }
    else if (tableView==graphTable)
    {
        return 1;
    }
    return 0;
       
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==symptomTable)
    {
      return 60;
    }
    else if (tableView==graphTable)
    {
        return 170;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==symptomTable)
    {
        static NSString *MyIdentifier = @"SymptomListCell";
        SymptomListCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[SymptomListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.lblSymptom.text=[[symptomArr valueForKey:@"symptomName"] objectAtIndex:indexPath.row];
        
        [cell.imageSymptom addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[[symptomArr valueForKey:@"image"]objectAtIndex:indexPath.row]isKindOfClass:[NSNull class]])
        {
            [cell.imageSymptom setImage:[UIImage imageNamed:@"people-img"] forState:UIControlStateNormal];
        }
        else
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * str_offline=[self documentsPathForFileName:[[symptomArr valueForKey:@"image"]objectAtIndex:indexPath.row]];
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:[[symptomArr valueForKey:@"image"]objectAtIndex:indexPath.row]] lastPathComponent]]];
            
            [cell.imageSymptom setImage:[UIImage imageWithContentsOfFile:getImagePath] forState:UIControlStateNormal];
        }
        
        cell.imageSymptom.tag=indexPath.row;
        
        return cell;
    }
    else if (tableView==graphTable)
    {
         static NSString *cellIdentifier = @"TableViewCell";
        TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:nil options:nil] firstObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell configUI:indexPath];
        return  cell;
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==graphTable)
    {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 30);
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.font = [UIFont systemFontOfSize:17];
        label.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
        label.text = section ? @"Bar":@"Health Overview";
        label.textColor = [UIColor colorWithRed:0.257 green:0.650 blue:0.478 alpha:1.000];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexpath=indexPath.row;
 
    if (tableView==graphTable)
    {
        ControlVC *Control = [self.storyboard instantiateViewControllerWithIdentifier:@"ControlVC"];
        [self.navigationController pushViewController:Control animated:YES];
    }
    else if (tableView==symptomTable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Go to Symptom?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes",nil];
        [alert show];
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
            
            
         NSString*   str_offline=[self documentsPathForFileName:strImagePath];
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






- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        CollectionView *collectionView = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectionView"];
        collectionView.symptomName=[[symptomArr valueForKey:@"symptomName"] objectAtIndex:indexpath];
        [self.navigationController pushViewController:collectionView animated:YES];
        

     }
    else if (buttonIndex == 0)
    {
        [alertView dismissWithClickedButtonIndex:1 animated:TRUE];
    }
}


@end
