//
//  CollectionViewCell.m
//  Dominik
//
//  Created by amit varma on 17/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "CollectionViewCell.h"
#import "Constants.h"

@implementation CollectionViewCell
@synthesize lblDate,lblPainLavel;
@synthesize btnAction,btnFood,btnLocation,btnPerson,btnPicture,btnRecord,btnWeather;



- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    if (IS_IPAD)
    {
        
    } else {
        
    }
    return nil;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)RecordAction:(id)sender {
}

- (IBAction)PictureAction:(id)sender {
}

- (IBAction)LocationAction:(id)sender {
}

- (IBAction)PeopleAction:(id)sender {
}

- (IBAction)WeatherAction:(id)sender {
}

- (IBAction)FoodAction:(id)sender {
}

- (IBAction)ActionPlanAction:(id)sender {
}
@end
