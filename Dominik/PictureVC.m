//
//  PictureVC.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "PictureVC.h"
#import "PictureCell.h"
#import "AppDelegate.h"
#import "FMDatabase.h"

@interface PictureVC ()
{
    NSString *path;
    FMDatabase *database;
    NSMutableArray *photoArr;
    NSString *userId;
    NSString *selectDate;
    NSMutableArray *dateArr;
    NSMutableDictionary *photoDic;
    NSMutableArray *fetchArray;

}

@end

@implementation PictureVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fetchArray=[[NSMutableArray alloc]init];
    photoArr=[[NSMutableArray alloc]init];
    dateArr =[[NSMutableArray alloc]init];
    photoDic=[[NSMutableDictionary alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    photoArr=[NSMutableArray new];
    dateArr =[[NSMutableArray alloc]init];
    
    
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    NSString *sql = [NSString stringWithFormat:@"SELECT date FROM SymptomTable where user_id='%@'",userId];
    FMResultSet *foodResults = [database executeQuery:sql];
    
    while([foodResults next])
    {
        [dateArr addObject:[foodResults resultDictionary]];
    }
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:dateArr];
    dateArr = [orderedSet array];
    
    [foodResults close];
    
    for (int i=0; i<dateArr.count; i++)
    {
        NSString *sql = [NSString stringWithFormat:@"SELECT image FROM SymptomTable where user_id='%@' AND date='%@' AND isActive='%@'",userId,[[dateArr valueForKey:@"date"]objectAtIndex:i],@"1"];
        FMResultSet *foodResults = [database executeQuery:sql];
        fetchArray=[[NSMutableArray alloc]init];
        while ([foodResults next])
        {
            [fetchArray addObject:[foodResults resultDictionary]];
            [photoDic setObject:fetchArray forKey:[[dateArr valueForKey:@"date"] objectAtIndex:i]];
        }
    }
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dateArr.count;    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Picture";
    PictureCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[PictureCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:MyIdentifier];
    }
    
    NSString *dateStr=[[dateArr valueForKey:@"date"]objectAtIndex: indexPath.row];
    NSMutableArray *imageArr=[photoDic valueForKey:dateStr];
    cell.lblDate.text=dateStr;
    
    cell.scrollView.contentSize=CGSizeMake(cell.scrollView.frame.size.width*(imageArr.count), cell.scrollView.frame.size.height);
    
    cell.btnBack.tag=indexPath.row;
    cell.btnNext.tag=indexPath.row;
    
    
    
    
    int width=0;
    
    for (int i=0; i<imageArr.count; i++)
    {
        CountVar=CountVar++;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString*  str_offline=[self documentsPathForFileName:[[imageArr valueForKey:@"image"]objectAtIndex:i]];
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:[[imageArr valueForKey:@"image"]objectAtIndex:i]] lastPathComponent]]];
        
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(width, 0, 304, 171)];
        imageview.image=[UIImage imageWithContentsOfFile:getImagePath];
        
        [cell.scrollView addSubview:imageview];
        width=width+304+5;
        
       
    }
    
    return cell;
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}

@end
