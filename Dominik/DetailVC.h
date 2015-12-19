//
//  DetailVC.h
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailVC : UIViewController
{
    IBOutlet UIButton *btnSymptomes;
    IBOutlet UIButton *btnFoodAndDrink;
    IBOutlet UIButton *btnLOcation;
    IBOutlet UIButton *btnPeople;
    IBOutlet UIButton *btnQuestion;
    
    
    IBOutlet UILabel *lblSymptomes;
    IBOutlet UILabel *lblFoodDrink;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblPeople;
    IBOutlet UILabel *lblQuestion;
    
    IBOutlet UILabel *lblDate;
    
    
}

- (IBAction)nextDate:(id)sender;
- (IBAction)previousDate:(id)sender;
- (IBAction)symptomesAction:(id)sender;
- (IBAction)foodDrinkAction:(id)sender;
- (IBAction)locationAction:(id)sender;
- (IBAction)peopleAction:(id)sender;
- (IBAction)questionAction:(id)sender;

- (IBAction)backBtnAction:(id)sender;
- (IBAction)logoutBtnAction:(id)sender;
@property(strong,nonatomic)NSString *strDate;


@end
