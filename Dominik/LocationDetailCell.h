//
//  LocationDetailCell.h
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapAnnotation.h"

@interface LocationDetailCell : UITableViewCell<MKMapViewDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UIImageView *ImageLocation;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

-(void)showLocationAnnotaion:(NSMutableArray *)locationArray and:(NSIndexPath *)indexPath;

@end
