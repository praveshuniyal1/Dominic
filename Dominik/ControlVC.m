//
//  ControlVC.m
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "ControlVC.h"
#import "ControlCell.h"
#import "AppDelegate.h"
#import "FMDatabase.h"

@interface ControlVC ()
{
    NSString *path;
    FMDatabase *database;
    NSString *userId;
    NSMutableArray *questionArr;
    BOOL isFrom;
}

@end

@implementation ControlVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
   
    


}
-(void)viewWillAppear:(BOOL)animated
{
    questionArr=[[NSMutableArray alloc]init];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM questionTbl where user_id='%@'",userId];
    FMResultSet *results = [database executeQuery:sql];
    
    while ([results next])
    {
        [questionArr addObject:[results resultDictionary]];
    }
    [database close];
    [results close];
    tblGraph.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

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

- (IBAction)fromBtnAction:(id)sender
{
    isFrom=YES;
    datePickerView.frame=CGRectMake(0, self.view.frame.size.height, datePickerView.frame.size.width, datePickerView.frame.size.height);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        datePickerView.frame=CGRectMake(0, self.view.frame.size.height-datePickerView.frame.size.height, datePickerView.frame.size.width, datePickerView.frame.size.height);
        
    } completion:^(BOOL finished) {

    }];
}

- (IBAction)toBtnAction:(id)sender
{
    isFrom=NO;
    datePickerView.frame=CGRectMake(0, self.view.frame.size.height, datePickerView.frame.size.width, datePickerView.frame.size.height);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        datePickerView.frame=CGRectMake(0, self.view.frame.size.height-datePickerView.frame.size.height, datePickerView.frame.size.width, datePickerView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];

}

- (IBAction)datePickerValueChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   [dateFormatter setDateFormat:@"ddMMM,yyyy"];
    NSString *formatedDate = [dateFormatter stringFromDate:datePicker.date];
    if (isFrom==YES) {
        lblFrom.text=formatedDate;
        
    }
    else{
        lblTo.text=formatedDate;
    }
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        datePickerView.frame=CGRectMake(0, self.view.frame.size.height, datePickerView.frame.size.width, datePickerView.frame.size.height);
        
    } completion:^(BOOL finished)
    {
        
        [self getGraphValue:lblFrom.text to:lblTo.text];
        
    }];

}

-(void)getGraphValue:(NSString*)from to:(NSString*)to
{
    
    
     questionArr=[[NSMutableArray alloc]init];
    
    database = [FMDatabase databaseWithPath:path];
    [database open];
     
     NSString *sql = [NSString stringWithFormat:@"SELECT * FROM questionTbl where user_id='%@' AND date BETWEEN '%@' and '%@'",userId,from,to];
     FMResultSet *results = [database executeQuery:sql];
     
     while ([results next])
     {
         [questionArr addObject:[results resultDictionary]];
     }
     [database close];
     [results close];
    [tblGraph reloadData];
    

}

#pragma tableview datasource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Control";
    ControlCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[ControlCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:MyIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell configUI:indexPath and:questionArr];
   

    
    return cell;
}


@end
