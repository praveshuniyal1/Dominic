//
//  LoginVC.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "LoginVC.h"
#import "CalenderVC.h"
#import "DetailVC.h"
#import "FMDatabase.h"
#import "AppDelegate.h"

@interface LoginVC ()
{
    NSString *path;
    FMDatabase *database;
}

@end

@implementation LoginVC

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneAction:(id)sender
{
//    CalenderVC *calenderView = [self.storyboard instantiateViewControllerWithIdentifier:@"CalenderVC"];
//    [self.navigationController pushViewController:calenderView animated:YES];
    
    
    database = [FMDatabase databaseWithPath:path];
    [database open];
    [database executeUpdate:@"create table UserPassword(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,name text,password text)"];
    
    
    NSString *searchString = txt_userName.text;
    NSString *likeParameter = [NSString stringWithFormat:@"%%%@%%", searchString];
    NSString *sql = @"SELECT name FROM UserPassword WHERE name LIKE ?";
    
    FMResultSet *name = [database executeQuery:sql, likeParameter];
    
    if ([name next])
    {
        
        NSString *likeParameter = [NSString stringWithFormat:@"%%%@%%", searchString];
        NSString *sql = @"SELECT password FROM UserPassword WHERE name LIKE ?";
        
        FMResultSet *passwords = [database executeQuery:sql, likeParameter];
        if ([passwords next])
        {
             NSString *password  = [passwords stringForColumn:@"password"];
            if ([password isEqualToString:txt_password.text])
            {
                CalenderVC *calenderView = [self.storyboard instantiateViewControllerWithIdentifier:@"CalenderVC"];
                [self.navigationController pushViewController:calenderView animated:YES];
                [database close];
                [passwords close];
                [name close];

            }
            else
            {
                [KappDelgate showAlertView:nil with:@"password is wrong"];
                [database close];
                [passwords close];
                [name close];
            }
            
        }
        
    }
    
    else
    {
    
        NSString *query = [NSString stringWithFormat:@"insert into UserPassword(name,password) values ('%@','%@')",
                           txt_userName.text,txt_password.text];
        [database executeUpdate:query];
        
        
        FMResultSet *results = [database executeQuery:@"SELECT * FROM UserPassword WHERE name LIKE ? and password LIKE ?",txt_userName.text,txt_password.text];
        
        if ([results next])
        {
            NSString *name = [results stringForColumn:@"name"];
            NSString *password  = [results stringForColumn:@"password"];
            NSLog(@"%@-%@",name,password);
            
            CalenderVC *calenderView = [self.storyboard instantiateViewControllerWithIdentifier:@"CalenderVC"];
            [self.navigationController pushViewController:calenderView animated:YES];
            
            NSLog(@"matched");
        } else
        {
            NSLog(@"not matched");
        }
        
        [database close];
        [results close];
    }
    
    [name close];

    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
