//
//  ViewController.m
//  Dominik
//
//  Created by amit varma on 02/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "ViewController.h"
#import "LoginVC.h"
#import "CalenderVC.h"
#import "AppDelegate.h"
#import "FMDatabase.h"

@interface ViewController ()
{
    NSString *path;
    FMDatabase *database;
}

@end

@implementation ViewController

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
    self.navigationController.navigationBarHidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPasswordAction:(id)sender
{
    LoginVC *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.navigationController pushViewController:loginView animated:YES];
    
}



- (IBAction)continueAction:(id)sender
{
    
    if (txt_userName.text.length==0)
    {
        [KappDelgate showAlertView:@"Error" with:@"Please enter user name"];
    }
    else
    {
     
        database = [FMDatabase databaseWithPath:path];
        [database open];
        [database executeUpdate:@"create table UserPassword(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,name text,password text)"];
        
        
        NSString *searchString = txt_userName.text;
        NSString *likeParameter = [NSString stringWithFormat:@"%%%@%%", searchString];
        NSString *sql = @"SELECT * FROM UserPassword WHERE name LIKE ?";
        
        FMResultSet *Results = [database executeQuery:sql, likeParameter];
        
        if ([Results next])
        {
            NSLog(@"%@-%@-%@",[Results stringForColumn:@"name"],[Results stringForColumn:@"password"],[Results stringForColumn:@"id"]);
            [[NSUserDefaults standardUserDefaults]setObject:[Results stringForColumn:@"id"] forKey:@"user_id"];

            CalenderVC *calenderView = [self.storyboard instantiateViewControllerWithIdentifier:@"CalenderVC"];
            [self.navigationController pushViewController:calenderView animated:YES];
            [database close];
        }
        else
        {
            
            NSString *query = [NSString stringWithFormat:@"insert into UserPassword(name) values ('%@')",
                               txt_userName.text];
            [database executeUpdate:query];
            
            
            FMResultSet *results = [database executeQuery:@"SELECT * FROM UserPassword WHERE name LIKE ?",txt_userName.text];
            
            if ([results next])
            {
                NSLog(@"%@-%@-%@",[results stringForColumn:@"name"],[results stringForColumn:@"password"],[results stringForColumn:@"id"]);
                [[NSUserDefaults standardUserDefaults]setObject:[results stringForColumn:@"id"] forKey:@"user_id"];
                
                
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
        
        [Results close];
        
       
    }
    
    
    
    
    
    

}
@end
