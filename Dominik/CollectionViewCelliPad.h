//
//  CollectionViewCelliPad.h
//  Dominik
//
//  Created by amit varma on 05/01/16.
//  Copyright © 2016 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCelliPad : UITableViewCell
{
     IBOutlet UIButton *btnRecord;
}




@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblPainLavel;


@property (strong, nonatomic) IBOutlet UIButton *btnRecord;
@property (strong, nonatomic) IBOutlet UIButton *btnPicture;

@property (strong, nonatomic) IBOutlet UIButton *btnLocation;
@property (strong, nonatomic) IBOutlet UIButton *btnPerson;

@property (strong, nonatomic) IBOutlet UIButton *btnWeather;

@property (strong, nonatomic) IBOutlet UIButton *btnFood;

@property (strong, nonatomic) IBOutlet UIButton *btnAction;



@end
