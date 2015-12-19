//
//  FurtherQuestionCell.m
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "FurtherQuestionCell.h"


@implementation FurtherQuestionCell
@synthesize lblAntrieb,lblBodyWt,lblMood,lblSleep,lblStress;
@synthesize sliderAntrieb,sliderBOdyWt,sliderMood,sliderSleep,sliderStress,lblDate,lblPainLavel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
