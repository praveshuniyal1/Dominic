//
//  WetherCell.m
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "WetherCell.h"

@implementation WetherCell
@synthesize lblAftTemp,lblEveTemp,lblMorTemp;
@synthesize imgAft,imgEve,imgMor;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
