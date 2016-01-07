//
//  ActiveDateCell.h
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface ActiveDateCell : UITableViewCell<NIDropDownDelegate>
{
    
   
   
}

@property (retain, nonatomic) IBOutlet UIButton *btnSelect1;


@property(strong,nonatomic)IBOutlet UILabel *lblSymptomes;
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;
@property (strong, nonatomic) IBOutlet UIButton *imageSymptom;

@property (strong, nonatomic) IBOutlet UITextField *textField;


- (IBAction)selectClicked:(id)sender;

-(void)loadDropDownValue;
@end
