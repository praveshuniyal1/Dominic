//
//  FurtherQuestionCell.h
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FurtherQuestionCell : UITableViewCell
@property(strong,nonatomic)   IBOutlet UISlider *sliderSleep;
@property(strong,nonatomic)IBOutlet UISlider *sliderStress;
@property(strong,nonatomic)IBOutlet UISlider *sliderMood;
@property(strong,nonatomic)IBOutlet UISlider *sliderAntrieb;
@property(strong,nonatomic)IBOutlet UISlider *sliderBOdyWt;

@property(strong,nonatomic)IBOutlet UILabel *lblSleep;
@property(strong,nonatomic)IBOutlet UILabel *lblStress;
@property(strong,nonatomic)IBOutlet UILabel *lblMood;
@property(strong,nonatomic)IBOutlet UILabel *lblAntrieb;
@property(strong,nonatomic)IBOutlet UILabel *lblBodyWt;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@property (strong, nonatomic) IBOutlet UILabel *lblPainLavel;

@end
