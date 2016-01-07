//
//  LocationVC.h
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationVC : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
{
    
    IBOutlet UISearchBar *search_Bar;
    IBOutlet UITableView *tblLocation;
    IBOutlet UITableView *tblSearch;
    
    
    IBOutlet UIButton *btnAction;
   
}


- (IBAction)AddAction:(id)sender;
@property(strong,nonatomic)NSString *date;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

- (IBAction)logoutAction:(id)sender;

- (IBAction)backbtnAction:(id)sender;
@end
