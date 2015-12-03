//
//  LGCalendarButton.m
//  LGCalender
//
//  Created by jamy on 15/6/30.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import "LGCalendarButton.h"

@implementation LGCalendarButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect: rect];
   
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, 0, rect.size.height/2);
    CGContextAddLineToPoint(contextRef,rect.size.width ,0);
    CGContextAddLineToPoint(contextRef,rect.size.width,rect.size.height);
    CGContextAddLineToPoint(contextRef,0, rect.size.height/2);
    
    CGContextSetFillColorWithColor(contextRef, [UIColor clearColor].CGColor);
    UIImage *image = [UIImage imageNamed:@"left-arrow"];
    CGContextDrawImage(contextRef, CGRectMake(0, 0, 15, 20), image.CGImage);
    CGContextFillPath(contextRef);
}

@end
