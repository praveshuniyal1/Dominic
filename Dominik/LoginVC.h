//
//  LoginVC.h
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController
{
    IBOutlet UITextField *txt_password;
    IBOutlet UITextField *txt_userName;
    
 
}
- (IBAction)doneAction:(id)sender;
@end
