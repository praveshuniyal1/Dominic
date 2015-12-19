//
//  PeopleVC.h
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface PeopleVC : UIViewController<UISearchDisplayDelegate,UISearchBarDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
{
    NSMutableArray *main_contact_Array;
   
    IBOutlet UISearchBar *search_Bar;
    IBOutlet UITableView *tblPeople;
    IBOutlet UITableView *tblContect;
    
    
}



- (IBAction)logoutAction:(id)sender;

- (IBAction)backbtnAction:(id)sender;
@end
