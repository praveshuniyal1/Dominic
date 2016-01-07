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
#import "AppDelegate.h"

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
    NSMutableArray *symptomArr;
    NSInteger arrCount;
    int sectionHeight;
    NSMutableArray *totalArr;
    BOOL temp;

    
}

@end

@implementation PersonDetailVC
@synthesize date;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    totalArr=[[NSMutableArray alloc]init];
    fetchArray=[[NSMutableArray alloc]init];
    personArr=[[NSMutableArray alloc]init];
    dateArr =[[NSMutableArray alloc]init];
    personDic=[[NSMutableDictionary alloc]init];
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
    
    personArr=[NSMutableArray new];
    dateArr =[[NSMutableArray alloc]init];
    
    
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    NSString *sql = [NSString stringWithFormat:@"SELECT date FROM peopleTbl where user_id='%@' ORDER BY date ASC",userId];
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
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM peopleTbl where user_id='%@' AND date='%@' ORDER BY date ASC",userId,[[dateArr valueForKey:@"date"]objectAtIndex:i]];
        FMResultSet *foodResults = [database executeQuery:sql];
        fetchArray=[[NSMutableArray alloc]init];
        while ([foodResults next])
        {
            [fetchArray addObject:[foodResults resultDictionary]];
            [personDic setObject:fetchArray forKey:[[dateArr valueForKey:@"date"] objectAtIndex:i]];
        }
        
        [database open];
        NSString *sqlsymptom = [NSString stringWithFormat:@"SELECT * FROM SymptomTable WHERE  date ='%@' AND isActive='%@' ORDER BY date ASC",[[dateArr valueForKey:@"date"]objectAtIndex:i],@"1"];
        
        FMResultSet *results = [database executeQuery:sqlsymptom];
        if([results next])
        {
            [symptomArr addObject:[results resultDictionary]];
        }

    }
    peopleTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
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
    NSLog(@"%@",personArr);
    
    
    if (temp==YES)
    {
        if (![[sectionTitle valueForKey:@"date"]isEqualToString:date])
        {
            for (int i=0; i<personArr.count; i++)
            {
                if ([totalArr containsObject:[personArr objectAtIndex:i]])
                {
                    NSLog(@"manu");
                }
                else
                {
                    [totalArr addObject:[personArr objectAtIndex:i]];
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
            arrCount=arrCount+(personArr.count);
            sectionHeight=0;
        }
        else
        {
            arrCount=arrCount+(personArr.count);
            sectionHeight=cell.frame.size.height*totalArr.count+(40*anIndex);
            
        }
        
       
        
    }
    
    
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
    
    if (isScrolled==YES)
    {
        [peopleTable setContentOffset:CGPointMake(0,sectionHeight) animated:NO];
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
    label.text = [sectionTitle valueForKey:@"date"];
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
