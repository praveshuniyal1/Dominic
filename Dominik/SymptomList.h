//
//  SymptomList.h
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SymptomList : UIViewController<UIAlertViewDelegate>
{
    
    IBOutlet UITableView *symptomTable;
    
    IBOutlet UITableView *graphTable;
    
}



- (IBAction)logoutAction:(id)sender;

- (IBAction)backbtnAction:(id)sender;
@end
