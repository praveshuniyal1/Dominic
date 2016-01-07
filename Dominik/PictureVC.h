//
//  PictureVC.h
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureVC : UIViewController

{
    NSInteger CountVar;
}
@property(strong,nonatomic)NSString *date;

- (IBAction)logoutAction:(id)sender;

- (IBAction)backbtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tablePicture;


@end
