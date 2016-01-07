//
//  WhatsPlanVC.h
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhatsPlanVC : UIViewController
{
    
    IBOutlet UISearchBar *searchBar;
    
    
    IBOutlet UITableView *whatsTable;
}
- (IBAction)AddAction:(id)sender;



- (IBAction)logoutAction:(id)sender;

- (IBAction)backbtnAction:(id)sender;
@end
