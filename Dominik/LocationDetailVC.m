//
//  LocationDetailVC.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "LocationDetailVC.h"
#import "LocationDetailCell.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "MapAnnotation.h"

@interface LocationDetailVC ()
{
    NSString *path;
    FMDatabase *database;
    NSString *userId;
    NSString *selectDate;
    NSString *latitute;
    NSString * longitude;
    NSInteger indexpath;
    
    
    NSMutableArray *locationArr;
    
    NSMutableArray *dateArr;
    NSMutableDictionary *locationDic;
    NSMutableArray *fetchArray;
    
}

@end

@implementation LocationDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationArr=[[NSMutableArray alloc]init];
    
    
    fetchArray=[[NSMutableArray alloc]init];
    locationArr=[[NSMutableArray alloc]init];
    dateArr =[[NSMutableArray alloc]init];
    locationDic=[[NSMutableDictionary alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];

 
}

-(void)viewWillAppear:(BOOL)animated
{
    
    locationArr=[NSMutableArray new];
    dateArr =[[NSMutableArray alloc]init];
    
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT date FROM locationTbl where user_id='%@'",userId];
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
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM locationTbl where user_id='%@' AND date='%@'",userId,[[dateArr valueForKey:@"date"]objectAtIndex:i]];
        FMResultSet *foodResults = [database executeQuery:sql];
        fetchArray=[[NSMutableArray alloc]init];
        while ([foodResults next])
        {
            [fetchArray addObject:[foodResults resultDictionary]];
            [locationDic setObject:fetchArray forKey:[[dateArr valueForKey:@"date"] objectAtIndex:i]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==(locationArr.count-1))
    {
        return 278;
    }
    else{
         return 65;
    }
    return 0;
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dateArr.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionTitle = [dateArr objectAtIndex:section];
    locationArr = [locationDic objectForKey:[sectionTitle valueForKey:@"date"]];
    return [locationArr count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"LocationDetail";
    LocationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[LocationDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:MyIdentifier];
    }
    
    NSDictionary *sectionTitle = [dateArr objectAtIndex:indexPath.section];
    locationArr = [locationDic objectForKey:[sectionTitle valueForKey:@"date"]];
    
    [cell showLocationAnnotaion:locationArr and:indexPath];
    cell.lblName.text=[[locationArr valueForKey:@"locationName"] objectAtIndex:indexPath.row];
    
    tableView.allowsSelection = NO;
    if ([[[locationArr valueForKey:@"image"]objectAtIndex:indexPath.row]isKindOfClass:[NSNull class]])
    {
        
    }
    else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* str_offline=[self documentsPathForFileName:[[locationArr valueForKey:@"image"]objectAtIndex:indexPath.row]];
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:[[locationArr valueForKey:@"image"]objectAtIndex:indexPath.row]] lastPathComponent]]];
        
        [cell.ImageLocation setImage:[UIImage imageWithContentsOfFile:getImagePath] ];
    }

    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]init];
    headerView.backgroundColor=[UIColor colorWithRed:41.0f/255.0f green:126.0f/255.0f blue:185.0f/255.0f alpha:1.0f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    NSDictionary *sectionTitle = [dateArr objectAtIndex:section];
    label.text = [sectionTitle valueForKey:@"date"];
    [headerView addSubview:label];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}




- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}


@end
