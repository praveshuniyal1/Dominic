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
    
    /*
    
    FMResultSet *results = [database executeQuery:@"select * from user"];
    while([results next]) {
        NSString *name = [results stringForColumn:@"name"];
        NSInteger age  = [results intForColumn:@"age"];
        NSLog(@"User: %@ - %ld",name, age);
    }
    [database close];
    */
   
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
        [database executeUpdate:@"create table UserPassword(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,name text)"];
        
        
        NSString *searchString = txt_userName.text;
        NSString *likeParameter = [NSString stringWithFormat:@"%%%@%%", searchString];
        NSString *sql = @"SELECT name FROM UserPassword WHERE name LIKE ?";
        
        FMResultSet *name = [database executeQuery:sql, likeParameter];
        
        if ([name next])
        {
            CalenderVC *calenderView = [self.storyboard instantiateViewControllerWithIdentifier:@"CalenderVC"];
            [self.navigationController pushViewController:calenderView animated:YES];
            [database close];
        }
        else
        {
            
            NSString *query = [NSString stringWithFormat:@"insert into UserPassword(name) values ('%@')",
                               txt_userName.text];
            [database executeUpdate:query];
            
            
            NSString *searchString = txt_userName.text;
            NSString *likeParameter = [NSString stringWithFormat:@"%%%@%%", searchString];
            NSString *sql = @"SELECT name FROM UserPassword WHERE name LIKE ?";
            
            FMResultSet *results = [database executeQuery:sql, likeParameter];

            while([results next])
            {
                NSString *name = [results stringForColumn:@"name"];
                NSInteger ID  = [results intForColumn:@"id"];
                NSLog(@"User: %@ - %ld",name, ID);
                
                
                CalenderVC *calenderView = [self.storyboard instantiateViewControllerWithIdentifier:@"CalenderVC"];
                [self.navigationController pushViewController:calenderView animated:YES];
            }
            [database close];
            [results close];
        }
        
        [name close];
        
       
    }
    
    
    
    
    
    

}
@end
