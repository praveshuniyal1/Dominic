//
//  FurtherQuestionVC.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "FurtherQuestionVC.h"
#import "FurtherQuestionCell.h"
#import "AppDelegate.h"
#import "FMDatabase.h"


@interface FurtherQuestionVC ()
{
    
    NSString *path;
    FMDatabase *database;
    NSString *userId;
    NSString *selectDate;
    NSMutableArray *questionArr;
    
}

@end

@implementation FurtherQuestionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    questionArr=[[NSMutableArray alloc]init];;
    
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
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM questionTbl where user_id='%@'",userId];
    FMResultSet *results = [database executeQuery:sql];
    
    while ([results next])
    {
        [questionArr addObject:[results resultDictionary]];
    }
    [database close];
    [results close];
    
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
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return questionArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"FurtherQuestionCell";
    FurtherQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[FurtherQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:MyIdentifier];
    }
    
    
    cell.sliderStress.value=[[[questionArr valueForKey:@"stress"] objectAtIndex:indexPath.row] floatValue];
    cell.sliderSleep.value=[[[questionArr valueForKey:@"howLong"] objectAtIndex:indexPath.row] floatValue];
    cell.sliderMood.value=[[[questionArr valueForKey:@"mood"] objectAtIndex:indexPath.row]floatValue];
    cell.sliderBOdyWt.value=[[[questionArr valueForKey:@"bodyWeight"] objectAtIndex:indexPath.row]floatValue];
    cell.sliderAntrieb.value=[[[questionArr valueForKey:@"antrieb"] objectAtIndex:indexPath.row]floatValue];
    
    cell.lblStress.text=[NSString stringWithFormat:@"%@ Lavel",[[questionArr valueForKey:@"stress"] objectAtIndex:indexPath.row]];
     cell.lblSleep.text=[NSString stringWithFormat:@"%@ Lavel",[[questionArr valueForKey:@"howLong"] objectAtIndex:indexPath.row]];
     cell.lblMood.text=[NSString stringWithFormat:@"%@ Lavel",[[questionArr valueForKey:@"mood"] objectAtIndex:indexPath.row]];
     cell.lblBodyWt.text=[NSString stringWithFormat:@"%@ Lavel",[[questionArr valueForKey:@"bodyWeight"] objectAtIndex:indexPath.row]];
    cell.lblAntrieb.text=[NSString stringWithFormat:@"%@ Lavel",[[questionArr valueForKey:@"antrieb"] objectAtIndex:indexPath.row]];
    cell.lblDate.text=[[questionArr valueForKey:@"date"] objectAtIndex:indexPath.row];
    
    
    return cell;
}


@end
