//
//  FoodDetailVC.m
//  Dominik
//
//  Created by amit varma on 17/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "FoodDetailVC.h"
#import "FoodDetailCell.h"
#import "FMDatabase.h"
#import "AppDelegate.h"

@interface FoodDetailVC ()
{
    NSString *path;
    FMDatabase *database;
    NSMutableArray *foodArr;
    NSString *userId;
    NSString *selectDate;
    NSMutableArray *dateArr;
    NSMutableDictionary *foodDic;
    NSMutableArray *fetchArray;
    NSMutableArray *symptomArr;
    NSInteger arrCount;
    int sectionHeight;
    NSMutableArray *totalArr;
    BOOL temp;
    
    
}

@end

@implementation FoodDetailVC
@synthesize date;

- (void)viewDidLoad
{
    [super viewDidLoad];

    totalArr=[[NSMutableArray alloc]init];
     fetchArray=[[NSMutableArray alloc]init];
    foodArr=[[NSMutableArray alloc]init];
    dateArr =[[NSMutableArray alloc]init];
    foodDic=[[NSMutableDictionary alloc]init];
    symptomArr=[[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
}

-(void)viewWillAppear:(BOOL)animated
{
    arrCount=0;
    sectionHeight=0;
    isScrolled=YES;
    temp=YES;

    [database open];
    foodArr=[NSMutableArray new];
    dateArr =[[NSMutableArray alloc]init];
   
    
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    NSString *sql = [NSString stringWithFormat:@"SELECT date FROM AddFoodTbl where user_id='%@' ORDER BY date ASC",userId];
    FMResultSet *foodResults = [database executeQuery:sql];
    
    while([foodResults next])
    {
        [dateArr addObject:[foodResults resultDictionary]];
    }
    
    
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:dateArr];
    dateArr = [orderedSet array];
    
    anIndex=[[dateArr valueForKey:@"date"] indexOfObject:date];
    if(NSNotFound == anIndex) {
        NSLog(@"not found");
        [KappDelgate showAlertView:nil with:@"Not found on this  date"];
        anIndex=0;
    }

    [foodResults close];
    
    for (int i=0; i<dateArr.count; i++)
    {
        [database open];
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM AddFoodTbl where user_id='%@' AND date='%@' ORDER BY date ASC",userId,[[dateArr valueForKey:@"date"]objectAtIndex:i]];
        FMResultSet *foodResults = [database executeQuery:sql];
        fetchArray=[[NSMutableArray alloc]init];
        while ([foodResults next])
        {
            [fetchArray addObject:[foodResults resultDictionary]];
            [foodDic setObject:fetchArray forKey:[[dateArr valueForKey:@"date"] objectAtIndex:i]];
        }
        
        [database open];

        NSString *sqlsymptom = [NSString stringWithFormat:@"SELECT * FROM SymptomTable WHERE  date ='%@' AND isActive='%@'",[[dateArr valueForKey:@"date"]objectAtIndex:i],@"1"];
        
        FMResultSet *results = [database executeQuery:sqlsymptom];
        if([results next])
        {
            [symptomArr addObject:[results resultDictionary]];
        }

        
    }
    
    foodTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

  
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
    foodArr = [foodDic objectForKey:[sectionTitle valueForKey:@"date"]];
    return [foodArr count];
   
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"FoodDetailCell";
    FoodDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[FoodDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    
    NSString *sectionTitle = [dateArr objectAtIndex:indexPath.section];
    foodArr = [foodDic objectForKey:[sectionTitle valueForKey:@"date"]];
    
    if (temp==YES)
    {
        if (![[sectionTitle valueForKey:@"date"]isEqualToString:date])
        {
            for (int i=0; i<foodArr.count; i++)
            {
                if ([totalArr containsObject:[foodArr objectAtIndex:i]])
                {
                    NSLog(@"manu");
                }
                else
                {
                    [totalArr addObject:[foodArr objectAtIndex:i]];
                }
            }
            
        }
        else
        {
            temp=NO;
            
        }
        
    }
    
    
    if (indexPath.section<=anIndex)
    {
        if (indexPath.section==0)
        {
            arrCount=0;
            arrCount=arrCount+(foodArr.count);
            sectionHeight=0;
        }
        else
        {
            arrCount=arrCount+(foodArr.count);
            sectionHeight=cell.frame.size.height*totalArr.count+(40*anIndex);
            
        }
        
        
        
    }
    
    if (isScrolled==YES)
    {
        [foodTable setContentOffset:CGPointMake(0,sectionHeight) animated:NO];
    }
    
    cell.lblFood.text=[[foodArr valueForKey:@"foodName"] objectAtIndex:indexPath.row];
    
    if ([[[foodArr valueForKey:@"image"]objectAtIndex:indexPath.row]isKindOfClass:[NSNull class]])
    {
        
    }
    else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
       NSString* str_offline=[self documentsPathForFileName:[[foodArr valueForKey:@"image"]objectAtIndex:indexPath.row]];
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:[[foodArr valueForKey:@"image"]objectAtIndex:indexPath.row]] lastPathComponent]]];
        
        [cell.imageFood setImage:[UIImage imageWithContentsOfFile:getImagePath] ];
    }
    
   
    if (isScrolled==YES)
    {
        [foodTable setContentOffset:CGPointMake(0,sectionHeight) animated:NO];
    }
    
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    isScrolled=NO;
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]init];
    headerView.backgroundColor=[UIColor colorWithRed:41.0f/255.0f green:126.0f/255.0f blue:185.0f/255.0f alpha:1.0f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 30)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    NSDictionary *sectionTitle = [dateArr objectAtIndex:section];
    label.text = [NSString stringWithFormat:@"  %@",[sectionTitle valueForKey:@"date"]];
    label.font=[UIFont systemFontOfSize:16.0f];
    [headerView addSubview:label];
    
    
    
    UILabel *symptomlabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, 200, 30)];
    symptomlabel.textColor = [UIColor whiteColor];
    
    symptomlabel.backgroundColor = [UIColor clearColor];
    NSDictionary *sectionTitle1 = [symptomArr objectAtIndex:section];
    symptomlabel.textAlignment=NSTextAlignmentRight;
    symptomlabel.text = [NSString stringWithFormat:@"%@,Pain lavel %@",[sectionTitle1 valueForKey:@"symptomName"],[sectionTitle1 valueForKey:@"painLavel"]];
    symptomlabel.font=[UIFont systemFontOfSize:13.0f];
    [headerView addSubview:symptomlabel];

    
    
    
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
