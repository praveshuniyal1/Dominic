//
//  ViewController.h
//  Dominik
//
//  Created by amit varma on 02/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    
    IBOutlet UITextField *txt_userName;
       
    IBOutlet UIButton *btn_AddPassword;
    
    IBOutlet UIButton *btn_continue;
}

- (IBAction)addPasswordAction:(id)sender;

- (IBAction)continueAction:(id)sender;



@end

