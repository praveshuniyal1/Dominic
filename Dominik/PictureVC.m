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
#import "Constants.h"

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
    int lastPageNumber;
    NSInteger anIndex;
    BOOL isScrolled;

}

@end

@implementation PictureVC
@synthesize date,tablePicture;

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
    isScrolled=YES;
    
    photoArr=[NSMutableArray new];
    dateArr =[[NSMutableArray alloc]init];
    
    
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
   // NSString *sql = [NSString stringWithFormat:@"SELECT date FROM SymptomTable where user_id='%@' and date='%@'",userId,date];
    NSString *sql = [NSString stringWithFormat:@"SELECT date FROM SymptomTable where user_id='%@' ORDER BY date ASC",userId];
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
    }

    
    
    
    [foodResults close];
    
    for (int i=0; i<dateArr.count; i++)
    {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SymptomTable where user_id='%@' AND date='%@' AND isActive='%@' ORDER BY date ASC",userId,[[dateArr valueForKey:@"date"]objectAtIndex:i],@"1"];
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
    
    if (isScrolled==YES)
    {
        [tablePicture setContentOffset:CGPointMake(0,cell.frame.size.height*anIndex) animated:NO];
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
        
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(width, 0, cell.frame.size.width-5, cell.frame.size.height-10)];
        imageview.image=[UIImage imageWithContentsOfFile:getImagePath];
        
        [cell.scrollView addSubview:imageview];
       
        
        UIImageView *btmImage=[[UIImageView alloc]initWithFrame:CGRectMake(width, cell.frame.size.height-90, cell.frame.size.width-5, 30)];
        btmImage.image=[UIImage imageNamed:@"Rectangle-2"];
        btmImage.alpha=0.65;
        
        UILabel *lblSymptom=[[UILabel alloc]initWithFrame:CGRectMake(width+5, cell.frame.size.height-90, cell.frame.size.width-5, 30)];
        lblSymptom.text=[[imageArr valueForKey:@"symptomName"]objectAtIndex:i];
        lblSymptom.textColor=[UIColor whiteColor];
        lblSymptom.font=[UIFont systemFontOfSize:14.0];
        
        [cell.scrollView addSubview:btmImage];
        [cell.scrollView addSubview:lblSymptom];
        
        
        cell.lblSymLvl.text=[NSString stringWithFormat:@"%@,Pain lavel %@",[[imageArr objectAtIndex:i]valueForKey:@"symptomName"],[[imageArr objectAtIndex:i] valueForKey:@"painLavel"]];

        
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    isScrolled=NO;
    
    /*
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 10;
    //if(y > h + reload_distance)
    if(y < 503)
    {
        NSLog(@"height=%f",y);
        lastPageNumber++;
        [[NSUserDefaults standardUserDefaults] setInteger:lastPageNumber forKey:@"PageNumber"];
        [self reLoadPastData];
        // Call the method.
    }
     */
     
}

-(void)reLoadPastData
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
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SymptomTable where user_id='%@' AND date='%@' AND isActive='%@'",userId,[[dateArr valueForKey:@"date"]objectAtIndex:i],@"1"];
        FMResultSet *foodResults = [database executeQuery:sql];
        fetchArray=[[NSMutableArray alloc]init];
        while ([foodResults next])
        {
            [fetchArray addObject:[foodResults resultDictionary]];
            [photoDic setObject:fetchArray forKey:[[dateArr valueForKey:@"date"] objectAtIndex:i]];
        }
    }
   
    [tablePicture reloadData];

}


@end
