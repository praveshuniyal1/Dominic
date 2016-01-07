//
//  PersonDetailVC.h
//  Dominik
//
//  Created by amit varma on 18/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonDetailVC : UIViewController
{
    
    IBOutlet UITableView *peopleTable;
    NSInteger anIndex;
    BOOL isScrolled;
    
}


@property(strong,nonatomic)NSString* date;

@end
