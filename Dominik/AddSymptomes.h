//
//  AddSymptomes.h
//  Dominik
//
//  Created by amit varma on 04/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSymptomes : UIViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
{
    IBOutlet UITableView *symptomTable;
    IBOutlet UISearchBar *searchBar;
}
- (IBAction)addAction:(id)sender;
- (IBAction)logOut:(id)sender;
- (IBAction)back:(id)sender;


@end
