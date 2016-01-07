//
//  ControlCell.h
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUChart.h"


@interface ControlCell : UITableViewCell<UUChartDataSource>

- (void)configUI:(NSIndexPath *)indexPath and:(NSMutableArray*)array;

@property (strong, nonatomic) IBOutlet UILabel *lblHeader;

@end
