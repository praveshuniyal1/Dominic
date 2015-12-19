//
//  CollectionViewCell.h
//  Dominik
//
//  Created by amit varma on 17/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UITableViewCell
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







- (IBAction)RecordAction:(id)sender;
- (IBAction)PictureAction:(id)sender;
- (IBAction)LocationAction:(id)sender;
- (IBAction)PeopleAction:(id)sender;
- (IBAction)WeatherAction:(id)sender;
- (IBAction)FoodAction:(id)sender;
- (IBAction)ActionPlanAction:(id)sender;

@end
