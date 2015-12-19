//
//  LocationManager.h
//  Hello
//
//  Created by webAstral on 11/3/14.
//  Copyright (c) 2014 Webastral. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#define kGoogleApi  @"http://maps.google.com/maps/api/geocode/json?latlng=30.7399738,76.7567368&sensor=false"


@interface LocationManager : NSObject<CLLocationManagerDelegate>
{
    NSString *longitudeLabel;
    NSString * latitudeLabel;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLGeocoder * geoCoder;
    
}

+(LocationManager*)locationInstance;
-(CLLocationCoordinate2D)getcurrentLocation;
- (NSArray*)getDistanceaccordingRadius:(int)circle;
-(void)reverseGeocodeAddrLatitude:(CLLocationDegrees)latitude
                        longitude:(CLLocationDegrees)longitude Success:(void(^)(NSString * currentAddress))sucess;
-(void)getLocationFromAddressString: (NSString*) addressStr Success:(void(^)(CLLocationCoordinate2D center))sucess;

@end
