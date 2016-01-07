//
//  ActiveDate.h
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Constants.h"
#import "NIDropDown.h"


@interface ActiveDate : UIViewController<UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UITableView *symptomTable;
    IBOutlet UILabel *lblDate;
    
    
    IBOutlet UILabel *lblMorning;
    IBOutlet UIImageView *imgMor;
    
    IBOutlet UILabel *lblAfternoon;
    IBOutlet UIImageView *imgAft;
    
    IBOutlet UILabel *lblEveaning;
    IBOutlet UIImageView *imgEve;
    
    NIDropDown *dropDown;
    
    
}

- (IBAction)logoutAction:(id)sender;
- (IBAction)backbtnAction:(id)sender;
- (IBAction)recordingsAction:(id)sender;
- (IBAction)editAction:(id)sender;
- (IBAction)dailyReminderAction:(id)sender;

- (IBAction)nextDate:(id)sender;
- (IBAction)previousDate:(id)sender;




- (IBAction)AddSymptomes:(id)sender;

@end
