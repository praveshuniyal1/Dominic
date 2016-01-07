//
//  WetherVC.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "WetherVC.h"
#import "WetherCell.h"
#import "AppDelegate.h"
#import "FMDatabase.h"

@interface WetherVC ()
{
    
    NSMutableArray *weatherArr;
    NSString *path;
    FMDatabase *database;
    NSString *userId;
    
    NSMutableArray *symptomArr;
    
    
}

@end

@implementation WetherVC
@synthesize date;


- (void)viewDidLoad
{

   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];

    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    isScrolled=YES;
    
     userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    weatherArr =[[NSMutableArray alloc]init];
    
    database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM weatherTable where user_id='%@' ORDER BY date ASC",userId];
    FMResultSet *results = [database executeQuery:sql];
    
    while ([results next])
    {
        [weatherArr addObject:[results resultDictionary]];
    }
    [results close];
    [database close];
    
    anIndex=[[weatherArr valueForKey:@"date"] indexOfObject:date];
    if(NSNotFound == anIndex) {
        NSLog(@"not found");
        [KappDelgate showAlertView:nil with:@"Not found on this  date"];
        anIndex=0;
    }
    
    
    symptomArr=[[NSMutableArray alloc]init];
    [database open];
    NSString *sqlsymptom = [NSString stringWithFormat:@"SELECT * FROM SymptomTable WHERE  isActive='%@' ORDER BY date ASC",@"1"];
    
    FMResultSet *resultssym = [database executeQuery:sqlsymptom];
    while ([resultssym next])
    {
        [symptomArr addObject:[resultssym resultDictionary]];
    }
    [resultssym close];
    [database close];
    

    
    
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
    return weatherArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Wether";
    WetherCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[WetherCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:MyIdentifier];
    }
    cell.lblMorTemp.text=[[weatherArr objectAtIndex:indexPath.row]valueForKey:@"morningTemp"];
    
    cell.imgMor.image = [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString: [[weatherArr objectAtIndex:indexPath.row] valueForKey:@"mornIcon"]]]];
    
    
    cell.lblAftTemp.text=[[weatherArr objectAtIndex:indexPath.row] valueForKey:@"afternoonTemp"];
    cell.imgAft.image = [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString: [[weatherArr objectAtIndex:indexPath.row] valueForKey:@"afnIcon"]]]];
    
    
    
    cell.lblEveTemp.text=[[weatherArr objectAtIndex:indexPath.row] valueForKey:@"eveaningTemp"];
    cell.imgEve.image = [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString: [[weatherArr objectAtIndex:indexPath.row] valueForKey:@"eveIcon"]]]];
    
    cell.lblDate.text=[[weatherArr valueForKey:@"date"] objectAtIndex:indexPath.row];
    cell.lblPainLavel.text=[NSString stringWithFormat:@"%@,Pain lavel %@",[[symptomArr objectAtIndex:indexPath.row]valueForKey:@"symptomName"] ,[[symptomArr objectAtIndex:indexPath.row]valueForKey:@"painLavel"]];
    
    if (isScrolled==YES)
    {
        [tableView setContentOffset:CGPointMake(0,cell.frame.size.height*anIndex) animated:NO];
    }


    
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    isScrolled=NO;
}


@end
