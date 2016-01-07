//
//  WetherCell.h
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WetherCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblMorTemp;
@property (strong, nonatomic) IBOutlet UILabel *lblAftTemp;

@property (strong, nonatomic) IBOutlet UILabel *lblEveTemp;

@property (strong, nonatomic) IBOutlet UIImageView *imgMor;

@property (strong, nonatomic) IBOutlet UIImageView *imgAft;
@property (strong, nonatomic) IBOutlet UIImageView *imgEve;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@property (strong, nonatomic) IBOutlet UILabel *lblPainLavel;



@end
