//
//  DetailVC.m
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "DetailVC.h"
#import "SymptomList.h"
#import "FoodDrinkVC.h"
#import "LocationVC.h"
#import "PeopleVC.h"
#import "AppDelegate.h"
#import "ActiveDate.h"
#import "FurtherQuestionVC.h"


@interface DetailVC ()

@end

@implementation DetailVC
@synthesize strDate;


- (void)viewDidLoad
{
    [super viewDidLoad];
     [KappDelgate makeRootView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
     lblDate.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectDate"]];
    
    if (btnSymptomes.isSelected==YES)
    {
        lblSymptomes.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    }
    else{
        lblSymptomes.textColor=[UIColor grayColor];
    }
    
    if (btnFoodAndDrink.isSelected==YES)
    {
        lblFoodDrink.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    }
    else{
        lblFoodDrink.textColor=[UIColor grayColor];
    }
    if (btnLOcation.isSelected==YES)
    {
        lblLocation.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    }
    else{
        lblLocation.textColor=[UIColor grayColor];
    }
    if (btnPeople.isSelected==YES)
    {
        lblPeople.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    }
    else{
        lblPeople.textColor=[UIColor grayColor];
    }
    if (btnQuestion.isSelected==YES)
    {
        lblQuestion.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    }
    else{
        lblQuestion.textColor=[UIColor grayColor];
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)symptomesAction:(id)sender
{
    [btnSymptomes setSelected:YES];
    lblSymptomes.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    ActiveDate *activeView = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveDate"];
    [self.navigationController pushViewController:activeView animated:YES];

}

- (IBAction)foodDrinkAction:(id)sender
{
    [btnFoodAndDrink setSelected:YES];
    
    lblFoodDrink.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    FoodDrinkVC *foodView = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodDrinkVC"];
    [self.navigationController pushViewController:foodView animated:YES];
}

- (IBAction)locationAction:(id)sender
{
    [btnLOcation setSelected:YES];
    
    lblLocation.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    LocationVC *locationView = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationVC"];
    [self.navigationController pushViewController:locationView animated:YES];
}

- (IBAction)peopleAction:(id)sender
{
    [btnPeople setSelected:YES];
    
    lblPeople.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    PeopleVC *peopleView = [self.storyboard instantiateViewControllerWithIdentifier:@"PeopleVC"];
    [self.navigationController pushViewController:peopleView animated:YES];
}


- (IBAction)questionAction:(id)sender
{
    [btnQuestion setSelected:YES];
    
    lblQuestion.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    FurtherQuestionVC *furtherView = [self.storyboard instantiateViewControllerWithIdentifier:@"FurtherQuestionVC"];
    [self.navigationController pushViewController:furtherView animated:YES];

}

- (IBAction)backBtnAction:(id)sender
{
    [btnSymptomes setSelected:NO];
    [btnFoodAndDrink setSelected:NO];
    [btnLOcation setSelected:NO];
    [btnQuestion setSelected:NO];
    [btnPeople setSelected:NO];
    
    
    
    [KappDelgate makeClenderAsRootView];
    
}

- (IBAction)logoutBtnAction:(id)sender
{
     [KappDelgate logout];
}
@end
