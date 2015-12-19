//
//  PeopleVC.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "PeopleVC.h"
#import "PeopleCell.h"
#import "AppDelegate.h"
#import "FMDatabase.h"

@interface PeopleVC ()
{
    NSMutableArray *contectList;
    NSArray *searchResults;
     NSMutableArray *peopleArr;
    BOOL  searchdata;
   
    NSString *path;
    FMDatabase *database;
    NSString *userId;
    NSString *selectDate;
    NSInteger indexpath;
}

@end

@implementation PeopleVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    contectList=[[NSMutableArray alloc]init];
    main_contact_Array=[[NSMutableArray alloc]init];
    peopleArr=[[NSMutableArray alloc]init];

    tblContect.hidden=YES;
    search_Bar.delegate=self;
    
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
    
    
    peopleArr=[NSMutableArray new];
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM peopleTbl where user_id='%@' and date='%@'",userId,selectDate];
    FMResultSet *peopleResults = [database executeQuery:sql];
    
    while([peopleResults next])
    {
        [peopleArr addObject:[peopleResults resultDictionary]];
    }
    
    [tblPeople reloadData];
    [peopleResults close];

    
    
    
    
    
    
    
    ///////// Used for access contect list
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted) {
        // if you got here, user had previously denied/revoked permission for your
        // app to access the contacts, and all you can do is handle this gracefully,
        // perhaps telling the user that they have to go to settings to grant access
        // to contacts
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (!addressBook) {
        NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
        return;
    }
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (error) {
            NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
        }
        
        if (granted) {
            // if they gave you permission, then just carry on
            
            [self listPeopleInAddressBook:addressBook];
        } else {
            // however, if they didn't give you permission, handle it gracefully, for example...
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // BTW, this is not on the main thread, so dispatch UI updates back to the main queue
                
                [[[UIAlertView alloc] initWithTitle:nil message:@"This app requires access to your contacts to function properly. Please visit to the \"Privacy\" section in the iPhone Settings app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        }
        
        CFRelease(addressBook);
    });

    
    
}
- (void)listPeopleInAddressBook:(ABAddressBookRef)addressBook
{
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger numberOfPeople = [allPeople count];
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
       // NSLog(@"Name:%@ %@", firstName, lastName);
        [contectList addObject:[NSString stringWithFormat:@"%@ %@",firstName,lastName]];
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumbers);
        for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
            NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumbers, i));
            //NSLog(@"  phone:%@", phoneNumber);
        }
        
        CFRelease(phoneNumbers);
        
       // NSLog(@"=============================================");
    }
//    NSLog(@"%@",contectList);
    for (int i =0; i<contectList.count; i++)
    {
        NSDictionary *dicitonary = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:[contectList objectAtIndex:i], nil] forKeys:[NSArray arrayWithObjects:@"name", nil]];
        
        [main_contact_Array addObject:dicitonary];
    }
    
}


#pragma mark searchbar delegates:-

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0)
    {
        tblContect.hidden=NO;
        searchdata = YES;
        NSPredicate *bPredicate =[NSPredicate predicateWithFormat:@"name contains[cd] %@",search_Bar.text];
        searchResults = [main_contact_Array filteredArrayUsingPredicate:bPredicate];
        [tblContect reloadData];
    }
    else
    {
        tblContect.hidden=YES;
        searchdata=NO;
        [tblPeople reloadData];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tblContect)
    {
        return [searchResults count];
    }
    else
    {
        return [peopleArr count];
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblPeople)
    {
        static NSString *MyIdentifier = @"PeopleCell";
        PeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        if (cell == nil)
        {
            cell = [[PeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        cell.lblName.text=[[peopleArr valueForKey:@"peopleName"]objectAtIndex:indexPath.row];
        [cell.btnImage addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnImage.tag=indexPath.row;
        
        if ([[[peopleArr valueForKey:@"image"]objectAtIndex:indexPath.row]isKindOfClass:[NSNull class]])
        {
            
        }
        else{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
          NSString*  str_offline=[self documentsPathForFileName:[[peopleArr valueForKey:@"image"]objectAtIndex:indexPath.row]];
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:[[peopleArr valueForKey:@"image"]objectAtIndex:indexPath.row]] lastPathComponent]]];
            
            [cell.btnImage setImage:[UIImage imageWithContentsOfFile:getImagePath] forState:UIControlStateNormal];
        }

        return cell;

    }
    else  if (tableView==tblContect)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text=[[searchResults valueForKey:@"name"]objectAtIndex:indexPath.row ];
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tblPeople)
    {
        
    }
    else  if (tableView==tblContect)
    {
        
        peopleArr=[NSMutableArray new];
        database = [FMDatabase databaseWithPath:path];
        [database open];
        [database executeUpdate:@"create table peopleTbl(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,user_id text,peopleName text,date text,image text)"];
        
        
        NSString *searchString = [[searchResults valueForKey:@"name"] objectAtIndex:indexPath.row];
        NSString *likeParameter = [NSString stringWithFormat:@"%%%@%%", searchString];
        NSString *sql = [NSString stringWithFormat:@"SELECT peopleName FROM peopleTbl WHERE peopleName ='%@'",searchString];
        
        FMResultSet *results = [database executeQuery:sql, likeParameter];
        if ([results next])
        {
            [KappDelgate showAlertView:@"Message" with:@"this People is allready added"];
            [results close];
        }
        else
        {
            NSString *query = [NSString stringWithFormat:@"insert into peopleTbl(user_id,peopleName,date) values ('%@','%@','%@')",
                               userId,searchString,[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"]];
            [database executeUpdate:query];
            
            NSString *sql = [NSString stringWithFormat:@"SELECT peopleName FROM peopleTbl where user_id='%@' and date='%@'",userId,selectDate];
            FMResultSet *results = [database executeQuery:sql];
            
            while ([results next])
            {
                [peopleArr addObject:[results resultDictionary]];
            }
            [database close];
            [results close];
            [tblPeople reloadData];
            
        }
       [self resignContectTable];

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
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM peopleTbl WHERE date='%@' AND peopleName='%@'",selectDate,[[peopleArr valueForKey:@"peopleName"] objectAtIndex:indexPath.row]];
        BOOL results = [database executeUpdate:sql];
        
        if(results)
        {
            [peopleArr removeObjectAtIndex:indexPath.row];
        }
        if (peopleArr.count==0)
        {
            peopleArr=[NSMutableArray new];
        }
        [database close];
        [tblPeople reloadData];
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma  set image to Documentdirectory

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
            NSString *query = [NSString stringWithFormat:@"UPDATE peopleTbl SET image='%@' where user_id='%@' AND date='%@' AND peopleName='%@'",
                               strImagePath,userId,selectDate,[[peopleArr objectAtIndex:indexpath] valueForKey:@"peopleName"]];
            BOOL results = [database executeUpdate:query];
            
            if (results)
            {
                peopleArr=[NSMutableArray new];
                FMResultSet *results = [database executeQuery:@"SELECT * FROM peopleTbl"];
                while ([results next])
                {
                    [peopleArr addObject:[results resultDictionary]];
                }
                [tblPeople reloadData];
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






///////////////////////////////////////////////
-(void)resignContectTable
{
    tblContect.hidden=YES;
    searchdata=NO;
    [tblPeople reloadData];
    [search_Bar setText:@""];
    [search_Bar setShowsCancelButton:NO animated:YES];
    [search_Bar resignFirstResponder];
}

- (IBAction)logoutAction:(id)sender
{
     [KappDelgate logout];
}

- (IBAction)backbtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
