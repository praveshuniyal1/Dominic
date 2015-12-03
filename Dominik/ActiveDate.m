//
//  ActiveDate.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "ActiveDate.h"
#import "ActiveDateCell.h"
#import "RecordingsVC.h"
#import "RecordingListVC.h"
#import "AppDelegate.h"
#import "RecordVC.h"

@interface ActiveDate ()

@end

@implementation ActiveDate

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logoutAction:(id)sender {
     [KappDelgate logout];
}

- (IBAction)backbtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)recordingsAction:(id)sender
{
    RecordVC *recordingView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordVC"];
    [self.navigationController pushViewController:recordingView animated:YES];
}

- (IBAction)editAction:(id)sender
{
    
}

- (IBAction)dailyReminderAction:(id)sender {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"ActiveDateCell";
    
    ActiveDateCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[ActiveDateCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
//   cell.lblSymptomes.text=@"dfsdf";
    
    
   
    return cell;
}
@end
