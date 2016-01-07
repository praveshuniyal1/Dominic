//
//  WhatsPlanVC.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "WhatsPlanVC.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "WhatsPlanCell.h"

@interface WhatsPlanVC ()
{
    NSString *path;
    FMDatabase *database;
    NSMutableArray *whatsInActiveArr;
    NSMutableArray *whatsActiveArr;
    NSString *userId;
    NSString *selectDate;
    NSMutableArray *finalArray;
}

@end

@implementation WhatsPlanVC

- (void)viewDidLoad
{
    [super viewDidLoad];


    
   
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    
}

-(void)viewWillAppear:(BOOL)animated
{

    whatsInActiveArr=[[NSMutableArray alloc]init];
    whatsActiveArr=[[NSMutableArray alloc]init];
    finalArray=[[NSMutableArray alloc]init];
    
    
    
    
    database = [FMDatabase databaseWithPath:path];
    [database open];
    
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM whatsTbl where user_id='%@' AND isActive='%@'",userId,@"0"];
        FMResultSet *results = [database executeQuery:sql];
        
        while ([results next])
        {
            [whatsInActiveArr addObject:[results resultDictionary]];
        }
        [results close];
        
        
        NSString *sqlActive = [NSString stringWithFormat:@"SELECT * FROM whatsTbl where user_id='%@' AND isActive='%@'",userId,@"1"];
        FMResultSet *resultsActive = [database executeQuery:sqlActive];
        
        while ([resultsActive next])
        {
            [whatsActiveArr addObject:[resultsActive resultDictionary]];
        }
    
    finalArray=[whatsActiveArr arrayByAddingObjectsFromArray:whatsInActiveArr];
    
   
        [database close];
        [resultsActive close];
        [whatsTable reloadData];
        
     whatsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return 2;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return whatsActiveArr.count;
    }
    else{
       return whatsInActiveArr.count;
    }
    return 0;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"WhatsPlanCell";
    WhatsPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[WhatsPlanCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:MyIdentifier];
    }
    
    [cell.ActiveSwitch addTarget:self action:@selector(setInActive:) forControlEvents:UIControlEventValueChanged];
    cell.ActiveSwitch.tag=indexPath.section*1000 +indexPath.row;
   
    
    if (indexPath.section==0)
    {
        cell.lblMedicine.text=[[whatsActiveArr valueForKey:@"medicineName"] objectAtIndex:indexPath.row];
        [cell.ActiveSwitch setOn:YES animated:YES];
          cell.infoBtn.hidden=YES;

    }
   else if (indexPath.section==1)
   {
       cell.lblMedicine.text=[[whatsInActiveArr valueForKey:@"medicineName"] objectAtIndex:indexPath.row];
      [cell.ActiveSwitch setOn:NO animated:YES];
       cell.infoBtn.hidden=NO;
       
    }
    
    
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        
        
        UIView *headerView=[[UIView alloc]init];
        headerView.backgroundColor=[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 30)];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
       
        label.text =@"   Active";
        [headerView addSubview:label];
        return headerView;

    }
    else if(section==1)
    {
        
        UIView *headerView=[[UIView alloc]init];
        headerView.backgroundColor=[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 30)];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text =@"   InActive";
        [headerView addSubview:label];
        return headerView;

    }
    return nil;
}


-(void)setInActive:(UISwitch*)sender
{
    NSInteger section = (sender.tag)/1000;
    NSInteger row = (sender.tag)%1000;
    
    NSLog(@"sender==%ld,tag==%ld",section,row);
    
    if([sender isOn])
    {
        NSLog(@"Switch is ON");
        
        if (section==0)
        {
            database = [FMDatabase databaseWithPath:path];
            [database open];
            NSString *sqlActive = [NSString stringWithFormat:@"UPDATE whatsTbl SET isActive='%@' WHERE user_id='%@' and medicineName='%@'",@"0",userId,[[whatsActiveArr valueForKey:@"medicineName"] objectAtIndex:row]];
            BOOL success = [database executeUpdate:sqlActive];
            
            if(success)
            {
                [self reloadTable];
            }
            else{
                
            }
            
        }
        else if (section==1)
        {
            database = [FMDatabase databaseWithPath:path];
            [database open];
            NSString *sqlActive = [NSString stringWithFormat:@"UPDATE whatsTbl SET isActive='%@' WHERE user_id='%@' and medicineName='%@'",@"1",userId,[[whatsInActiveArr valueForKey:@"medicineName"] objectAtIndex:row]];
            BOOL success = [database executeUpdate:sqlActive];
            
            if(success)
            {
                [self reloadTable];
            }
            else{
                
            }
            
        }

    }
    else
    {
        NSLog(@"Switch is OFF");
        
        if (section==0)
        {
            database = [FMDatabase databaseWithPath:path];
            [database open];
            NSString *sqlActive = [NSString stringWithFormat:@"UPDATE whatsTbl SET isActive='%@' WHERE user_id='%@' and medicineName='%@'",@"0",userId,[[whatsActiveArr valueForKey:@"medicineName"] objectAtIndex:row]];
            BOOL success = [database executeUpdate:sqlActive];
            
            if(success)
            {
                [self reloadTable];
            }
            else{
                
            }
            
        }
        else if (section==1)
        {
            database = [FMDatabase databaseWithPath:path];
            [database open];
            NSString *sqlActive = [NSString stringWithFormat:@"UPDATE whatsTbl SET isActive='%@' WHERE user_id='%@' and medicineName='%@'",@"1",userId,[[whatsInActiveArr valueForKey:@"medicineName"] objectAtIndex:row]];
            BOOL success = [database executeUpdate:sqlActive];
            
            if(success)
            {
                [self reloadTable];
            }
            else{
                
            }
        }
    }
}





-(void)reloadTable
{
    whatsInActiveArr=[[NSMutableArray alloc]init];
    whatsActiveArr=[[NSMutableArray alloc]init];
    
    database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM whatsTbl where user_id='%@' AND isActive='%@'",userId,@"0"];
    FMResultSet *results = [database executeQuery:sql];
    
    while ([results next])
    {
        [whatsInActiveArr addObject:[results resultDictionary]];
    }
    [results close];
    
    
    NSString *sqlActive = [NSString stringWithFormat:@"SELECT * FROM whatsTbl where user_id='%@' AND isActive='%@'",userId,@"1"];
    FMResultSet *resultsActive = [database executeQuery:sqlActive];
    
    while ([resultsActive next])
    {
        [whatsActiveArr addObject:[resultsActive resultDictionary]];
    }
    
     finalArray=[whatsActiveArr arrayByAddingObjectsFromArray:whatsInActiveArr];
    [database close];
    [resultsActive close];
    [whatsTable reloadData];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddAction:(id)sender
{
    whatsInActiveArr=[[NSMutableArray alloc]init];
    whatsActiveArr=[[NSMutableArray alloc]init];
    
    database = [FMDatabase databaseWithPath:path];
    [database open];
    [database executeUpdate:@"create table whatsTbl(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,user_id text,medicineName text,isActive text)"];
    
    
    NSString *searchString = searchBar.text;
    NSString *likeParameter = [NSString stringWithFormat:@"%%%@%%", searchString];
    NSString *sql = [NSString stringWithFormat:@"SELECT medicineName FROM whatsTbl WHERE medicineName ='%@'",searchString];
    
    FMResultSet *results = [database executeQuery:sql, likeParameter];
    if ([results next])
    {
        [KappDelgate showAlertView:@"Message" with:@"this medicine is allready added"];
        [results close];
    }
    else
    {
        NSString *query = [NSString stringWithFormat:@"insert into whatsTbl(user_id,medicineName,isActive) values ('%@','%@','%@')",
                           userId,searchBar.text,@"0"];
        [database executeUpdate:query];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM whatsTbl where user_id='%@' AND isActive='%@'",userId,@"0"];
        FMResultSet *results = [database executeQuery:sql];
        
        while ([results next])
        {
            [whatsInActiveArr addObject:[results resultDictionary]];
        }
        [results close];
        
        
        NSString *sqlActive = [NSString stringWithFormat:@"SELECT * FROM whatsTbl where user_id='%@' AND isActive='%@'",userId,@"1"];
        FMResultSet *resultsActive = [database executeQuery:sqlActive];
        
        while ([resultsActive next])
        {
            [whatsActiveArr addObject:[resultsActive resultDictionary]];
        }
        [database close];
        [resultsActive close];
        [whatsTable reloadData];
        
        
    }

    
}

- (IBAction)logoutAction:(id)sender{
     [KappDelgate logout];
}

- (IBAction)backbtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
