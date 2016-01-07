//
//  RecordingListVC.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "RecordingListVC.h"
#import "RecordingListCell.h"
#import "RecordingsVC.h"
#import "FMDatabase.h"
#import "AppDelegate.h"

@interface RecordingListVC ()
{
    NSString *recordPath;
    FMDatabase *database;
    NSString *userId;
    NSString *selectDate;
    NSMutableArray *recordArr;
    NSString *path;
   
}

@end

@implementation RecordingListVC
@synthesize date;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    recordArr=[[NSMutableArray alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
   

}
-(void)viewWillAppear:(BOOL)animated
{
    isScrolled=YES;
    
    recordArr=[NSMutableArray new];
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM recordTbl where user_id='%@' and date='%@' ORDER BY date ASC",userId,selectDate];
    FMResultSet *recordResults = [database executeQuery:sql];
    
    while([recordResults next])
    {
        [recordArr addObject:[recordResults resultDictionary]];
    }
    [recordResults close];
    
    anIndex=[[recordArr valueForKey:@"date"] indexOfObject:date];
    if(NSNotFound == anIndex) {
        NSLog(@"not found");
         [KappDelgate showAlertView:nil with:@"Not found on this  date"];
        anIndex=0;
    }
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutAction:(id)sender{
    
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
    
    return recordArr.count;    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"RecordingList";
    RecordingListCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[RecordingListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    cell.lblRecordName.text=[[recordArr valueForKey:@"recordTitle"]objectAtIndex:indexPath.row];
    cell.lblDate.text=[[recordArr valueForKey:@"date"]objectAtIndex:indexPath.row];
    cell.lblDetail.text=[[recordArr valueForKey:@"recordName"]objectAtIndex:indexPath.row];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordingsVC *recordingView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordingsVC"];
    recordingView.recordDic=[recordArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:recordingView animated:YES];
    }

@end
