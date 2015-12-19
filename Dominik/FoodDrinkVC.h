//
//  FoodDrinkVC.h
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodDrinkVC : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UISearchBar *searchBar;
    
    
    IBOutlet UITableView *foodTable;
}


- (IBAction)logoutAction:(id)sender;

- (IBAction)backbtnAction:(id)sender;
- (IBAction)addAction:(id)sender;

@end
