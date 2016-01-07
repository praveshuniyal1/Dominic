//
//  SymptomesVC.m
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "SymptomesVC.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "symptomCell.h"

@interface SymptomesVC ()
{
    NSMutableArray *unHideArr;
    NSMutableArray *HideArr;
    NSString *path;
    FMDatabase *database;
     NSString *userId;
}

@end

@implementation SymptomesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    unHideArr=[[NSMutableArray alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];


}
-(void)viewWillAppear:(BOOL)animated
{
    HideArr=[[NSMutableArray alloc]init];
    unHideArr=[[NSMutableArray alloc]init];
    
    database = [FMDatabase databaseWithPath:path];
    [database open];
    
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM AddSymptomTable where user_id='%@' AND isHidden='%@'",userId,@"0"];
    FMResultSet *results = [database executeQuery:sql];
    while ([results next])
    {
        [unHideArr addObject:[results resultDictionary]];
    }
    [symptomTbl reloadData];
   
    [results close];
    
    
    [database open];
    NSString *sqlHIde = [NSString stringWithFormat:@"SELECT * FROM AddSymptomTable where user_id='%@' AND isHidden='%@'",userId,@"1"];
    FMResultSet *resultsHIde = [database executeQuery:sqlHIde];
    while ([resultsHIde next])
    {
        [HideArr addObject:[resultsHIde resultDictionary]];
    }
    [symptomTbl reloadData];
    
    [resultsHIde close];
     symptomTbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];


}

#pragma tableview datasource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0)
    {
        return unHideArr.count;
    }
    else{
        return HideArr.count;
    }
    return 0;
    
       //count number of row from counting array hear cataGorry is An Array
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"symptomCell";
    symptomCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[symptomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    
    
    [cell.hideBtn addTarget:self action:@selector(setHIde:) forControlEvents:UIControlEventTouchUpInside];
    cell.hideBtn.tag=indexPath.section*1000 +indexPath.row;
    
    
    if (indexPath.section==0)
    {
        cell.lblSymptom.text=[[unHideArr valueForKey:@"symptomName"]objectAtIndex:indexPath.row];
        [cell.hideBtn setSelected:YES];
        [cell.hideBtn setTitle:@"Hide" forState:UIControlStateNormal];
    }
    else if (indexPath.section==1)
    {
        cell.lblSymptom.text=[[HideArr valueForKey:@"symptomName"]objectAtIndex:indexPath.row];
        [cell.hideBtn setSelected:NO];
        [cell.hideBtn setTitle:@"Unhide" forState:UIControlStateNormal];
    }
    
    return cell;
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
        
        label.text =@"   Active Symptom";
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
        label.text =@"   Hidden Symptom";
        [headerView addSubview:label];
        return headerView;
        
    }
    return nil;
}


-(void)setHIde:(UIButton*)sender
{
    NSInteger section = (sender.tag)/1000;
    NSInteger row = (sender.tag)%1000;
    
    NSLog(@"sender==%ld,tag==%ld",section,row);
    
    if([sender isSelected])
    {
        NSLog(@"Switch is ON");
        
        
            database = [FMDatabase databaseWithPath:path];
            [database open];
            NSString *sqlActive = [NSString stringWithFormat:@"UPDATE AddSymptomTable SET isHidden='%@' WHERE user_id='%@' and symptomName='%@'",@"1",userId,[[unHideArr valueForKey:@"symptomName"] objectAtIndex:row]];
            BOOL success = [database executeUpdate:sqlActive];
            
            if(success)
            {
                
                [self reloadTable];
            }
        
        
        }
        else if (section==1)
        {
            database = [FMDatabase databaseWithPath:path];
            [database open];
            NSString *sqlActive = [NSString stringWithFormat:@"UPDATE AddSymptomTable SET isHidden='%@' WHERE user_id='%@' and symptomName='%@'",@"0",userId,[[HideArr valueForKey:@"symptomName"] objectAtIndex:row]];
            BOOL success = [database executeUpdate:sqlActive];
            
            if(success)
            {
                [self reloadTable];
            }
            
            
//            [database open];
//            NSString *sql = [NSString stringWithFormat:@"UPDATE SymptomTable SET isHidden='%@' WHERE user_id='%@' and symptomName='%@'",@"0",userId,[[unHideArr valueForKey:@"symptomName"] objectAtIndex:row]];
//            BOOL successsym = [database executeUpdate:sql];
//            
//            if(successsym)
//            {
//                [self reloadTable];
//            }

            
        }
        
}


-(void)reloadTable
{
    HideArr=[[NSMutableArray alloc]init];
    unHideArr=[[NSMutableArray alloc]init];

    
    database = [FMDatabase databaseWithPath:path];
    [database open];
    
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM AddSymptomTable where user_id='%@' AND isHidden='%@'",userId,@"0"];
    FMResultSet *results = [database executeQuery:sql];
    while ([results next])
    {
        [unHideArr addObject:[results resultDictionary]];
    }
//    [symptomTbl reloadData];
    
    [results close];
    
    
    [database open];
    NSString *sqlHIde = [NSString stringWithFormat:@"SELECT * FROM AddSymptomTable where user_id='%@' AND isHidden='%@'",userId,@"1"];
    FMResultSet *resultsHIde = [database executeQuery:sqlHIde];
    while ([resultsHIde next])
    {
        [HideArr addObject:[resultsHIde resultDictionary]];
    }
    [symptomTbl reloadData];
    
    symptomTbl.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [resultsHIde close];
    
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
