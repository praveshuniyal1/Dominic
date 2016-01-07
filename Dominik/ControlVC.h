//
//  ControlVC.h
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlVC : UIViewController
{
    
    IBOutlet UIView *datePickerView;
    IBOutlet UIDatePicker *datePicker;
    
    
    IBOutlet UILabel *lblFrom;
    IBOutlet UILabel *lblTo;
    
    
    IBOutlet UITableView *tblGraph;
    
   
    
    
}

- (IBAction)logoutAction:(id)sender;
- (IBAction)backbtnAction:(id)sender;

- (IBAction)fromBtnAction:(id)sender;
- (IBAction)toBtnAction:(id)sender;

- (IBAction)datePickerValueChanged:(id)sender;

@end
