//
//  ControlCell.m
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "ControlCell.h"
#import "UUChart.h"



@implementation ControlCell
{
        NSIndexPath *path;
        UUChart *chartView;
    NSMutableArray *finalArr;
    NSMutableArray *stressArr;
    NSMutableArray *returnXlabelArr;
    NSMutableArray *returnYlabelArr;

    
}
@synthesize lblHeader;
- (void)awakeFromNib
{
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configUI:(NSIndexPath *)indexPath and:(NSMutableArray*)array
{
    finalArr=[[NSMutableArray alloc]init];
    stressArr=[[NSMutableArray alloc]init];
    returnXlabelArr=[[NSMutableArray alloc]init];
    returnYlabelArr=[[NSMutableArray alloc]init];
    
    if (indexPath.row==0)
    {
        for (int i=0; i<array.count; i++)
        {
            [finalArr addObject:[[array objectAtIndex:i]valueForKey:@"howLong"]];
            lblHeader.text=@"   Sleep";
         
        }
    }
     if (indexPath.row==1)
    {
        for (int i=0; i<array.count; i++)
        {
            [finalArr addObject:[[array objectAtIndex:i]valueForKey:@"stress"]];
            lblHeader.text=@"   Stress";
        }
    }
    if (indexPath.row==2)
    {
        for (int i=0; i<array.count; i++)
        {
            [finalArr addObject:[[array objectAtIndex:i]valueForKey:@"antrieb"]];
            lblHeader.text=@"   Antrieb";
        }
    }
    if (indexPath.row==3)
    {
        for (int i=0; i<array.count; i++)
        {
            [finalArr addObject:[[array objectAtIndex:i]valueForKey:@"mood"]];
            lblHeader.text=@"   Mood";
        }
    }

    if (indexPath.row==4)
    {
        for (int i=0; i<array.count; i++)
        {
            [finalArr addObject:[[array objectAtIndex:i]valueForKey:@"bodyWeight"]];
            lblHeader.text=@"   Body Weight";
        }
    }


   
    
    
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    path = indexPath;
    
    chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 50, [UIScreen mainScreen].bounds.size.width-20, 150)
                                              withSource:self
                                               withStyle:indexPath.section==1?UUChartBarStyle:UUChartLineStyle];
    [chartView showInView:self.contentView];
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    for (int i=0; i<finalArr.count; i++)
    {
        NSString *str=[NSString stringWithFormat:@"%d",i+1];
        [returnXlabelArr addObject:str];
        
    }

    
        return @[returnXlabelArr];
   // return @[@"1",@"2"];
    
}
//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    return @[finalArr];
   
}
#pragma mark - @optional
//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[UUGreen,UURed,UUBrown];
}
//显示数值范围
- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    if (path.row==0) {
        return CGRangeMake(60, 10);
    }
    if (path.row==2) {
        return CGRangeMake(100, 0);
    }
    return CGRangeZero;
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart
{
    if (path.row==2) {
        return CGRangeMake(25, 75);
    }
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
{
    return path.row==2;
}

@end
