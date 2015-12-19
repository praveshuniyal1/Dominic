//
//  PictureCell.m
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "PictureCell.h"

@implementation PictureCell
{
    int inctrmnt;
}
@synthesize scrollView,imageView,lblDate,btnBack,btnNext;



- (void)awakeFromNib
{
    inctrmnt=0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)back:(id)sender
{
  //  NSLog(@"sender tag ---- >>>>>>>>>%ld",(long)[sender tag]);
   
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
}

- (IBAction)forward:(id)sender
{
   // NSLog(@"sender tag ---- >>>>>>>>>%ld",(long)[sender tag]);
    
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
}
@end
