//
//  PersonDetailVC.m
//  Dominik
//
//  Created by amit varma on 18/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "PersonDetailVC.h"
#import "FMDatabase.h"
#import "PersonDetailCell.h"

@interface PersonDetailVC ()
{
    NSString *path;
    FMDatabase *database;
    NSMutableArray *personArr;
    NSString *userId;
    NSString *selectDate;
    NSMutableArray *dateArr;
    NSMutableDictionary *personDic;
    NSMutableArray *fetchArray;

    
}

@end

@implementation PersonDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fetchArray=[[NSMutableArray alloc]init];
    personArr=[[NSMutableArray alloc]init];
    dateArr =[[NSMutableArray alloc]init];
    personDic=[[NSMutableDictionary alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    personArr=[NSMutableArray new];
    dateArr =[[NSMutableArray alloc]init];
    
    
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    NSString *sql = [NSString stringWithFormat:@"SELECT date FROM peopleTbl where user_id='%@'",userId];
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
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM peopleTbl where user_id='%@' AND date='%@'",userId,[[dateArr valueForKey:@"date"]objectAtIndex:i]];
        FMResultSet *foodResults = [database executeQuery:sql];
        fetchArray=[[NSMutableArray alloc]init];
        while ([foodResults next])
        {
            [fetchArray addObject:[foodResults resultDictionary]];
            [personDic setObject:fetchArray forKey:[[dateArr valueForKey:@"date"] objectAtIndex:i]];
        }
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dateArr.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionTitle = [dateArr objectAtIndex:section];
    personArr = [personDic objectForKey:[sectionTitle valueForKey:@"date"]];
    return [personArr count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"PersonDetailCell";
    PersonDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[PersonDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    
    NSString *sectionTitle = [dateArr objectAtIndex:indexPath.section];
    personArr = [personDic objectForKey:[sectionTitle valueForKey:@"date"]];
    
    
    cell.lblPerson.text=[[personArr valueForKey:@"peopleName"] objectAtIndex:indexPath.row];
    
    
    if ([[[personArr valueForKey:@"image"]objectAtIndex:indexPath.row]isKindOfClass:[NSNull class]])
    {
        
    }
    else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* str_offline=[self documentsPathForFileName:[[personArr valueForKey:@"image"]objectAtIndex:indexPath.row]];
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:[[personArr valueForKey:@"image"]objectAtIndex:indexPath.row]] lastPathComponent]]];
        
        [cell.imagePerson setImage:[UIImage imageWithContentsOfFile:getImagePath] ];
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


- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
