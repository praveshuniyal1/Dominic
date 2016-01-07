//
//  CollectionViewCelliPad.m
//  Dominik
//
//  Created by amit varma on 05/01/16.
//  Copyright © 2016 trigma. All rights reserved.
//

#import "CollectionViewCelliPad.h"

@implementation CollectionViewCelliPad

@synthesize lblDate,lblPainLavel;
@synthesize btnAction,btnFood,btnLocation,btnPerson,btnPicture,btnRecord,btnWeather;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
