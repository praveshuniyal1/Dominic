//
//  MapAnnotation.m
//  Dominik
//
//  Created by amit varma on 15/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "MapAnnotation.h"
#import <AddressBook/AddressBook.h>


@interface MapAnnotation ()
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@end
@implementation MapAnnotation

- (id)initWithName:(NSString*)title address:(NSString*)subtitle coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init])) {
        if ([title isKindOfClass:[NSString class]]) {
            self.title = title;
        } else {
            self.title = @"Unknown charge";
        }
        self.subtitle = subtitle;
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _title;
}

- (NSString *)subtitle {
    return _subtitle;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _subtitle};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
