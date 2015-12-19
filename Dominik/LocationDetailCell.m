//
//  LocationDetailCell.m
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "LocationDetailCell.h"

@implementation LocationDetailCell
@synthesize lblName,ImageLocation,mapView;

- (void)awakeFromNib
{
    self.mapView.delegate = self;
    self.mapView.showsUserLocation=YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showLocationAnnotaion:(NSMutableArray *)locationArray and:(NSIndexPath *)indexPath
{
   
    for (int i=0; i<locationArray.count; i++)
    {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[[locationArray valueForKey:@"lat"] objectAtIndex:i]doubleValue];
        coordinate.longitude = [[[locationArray valueForKey:@"long"] objectAtIndex: i]doubleValue];
        MapAnnotation *annotation = [[MapAnnotation alloc] initWithName:[[locationArray valueForKey:@"locationName"] objectAtIndex:i] address:@"" coordinate:coordinate] ;
        self.mapView.delegate = self;
        [self.mapView addAnnotation:annotation];
    }
   
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 10000, 10000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
}




- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"MapAnnotation";
    if ([annotation isKindOfClass:[MapAnnotation class]])
    {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"location-pin"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    else if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"slider-toggle-btn-red"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }

    
    return nil;
}


@end
