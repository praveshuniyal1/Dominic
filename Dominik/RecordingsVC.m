//
//  RecordingsVC.m
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "RecordingsVC.h"
#import "AppDelegate.h"

@interface RecordingsVC ()

@end

@implementation RecordingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
