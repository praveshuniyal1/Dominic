//
//  MapAnnotation.h
//  Dominik
//
//  Created by amit varma on 15/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject<MKAnnotation>
- (id)initWithName:(NSString*)title address:(NSString*)subtitle coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
