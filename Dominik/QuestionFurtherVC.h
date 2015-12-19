//
//  QuestionFurtherVC.h
//  Dominik
//
//  Created by amit varma on 06/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface QuestionFurtherVC : UIViewController<NIDropDownDelegate>
{
    IBOutlet UIButton *btnSelect;
    NIDropDown *dropDown;
    
    
    IBOutlet UIButton *btnStress;
    NIDropDown  *dropDownStress;
    
    
    IBOutlet UIButton *btnHowlong;
    NIDropDown *dropDownHowlong;
    
    IBOutlet UIButton *btnAntrieb;
    NIDropDown *dropDownAntrieb;
    
    
    IBOutlet UIButton *btnBodyWeight;
     NIDropDown *dropDownBodyWeight;
    
    
    IBOutlet UILabel *lblMood;
    IBOutlet UILabel *lblstress;
    IBOutlet UILabel *lblHowLong;
    IBOutlet UILabel *lblBodyWeight;
    IBOutlet UILabel *lblAntrieb;
    
    
    IBOutlet UITextField *txt_description;
    
    
}

@property (retain, nonatomic) IBOutlet UIButton *btnSelect;
- (IBAction)selectClicked:(id)sender;
- (IBAction)stressClicked:(id)sender;
- (IBAction)howLongClicked:(id)sender;
- (IBAction)antriebClicked:(id)sender;
- (IBAction)bodyWightClicked:(id)sender;

- (IBAction)checkAction:(id)sender;

- (IBAction)backAction:(id)sender;



-(void)rel;


@end
