//
//  FoodDetailVC.h
//  Dominik
//
//  Created by amit varma on 17/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodDetailVC : UIViewController
{
    
    IBOutlet UITableView *foodTable;
    
    NSInteger anIndex;
    BOOL isScrolled;
}

@property(strong,nonatomic)NSString* date;
- (IBAction)backAction:(id)sender;


@end
