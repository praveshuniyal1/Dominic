//
//  FoodDrinkVC.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "FoodDrinkVC.h"
#import "FoodDrinkCell.h"
#import "AppDelegate.h"

@interface FoodDrinkVC ()

@end

@implementation FoodDrinkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    return 1;    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"FoodDrink";
    FoodDrinkCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[FoodDrinkCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:MyIdentifier];
    }
    
    return cell;
}

@end
