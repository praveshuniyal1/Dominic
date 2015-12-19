//
//  AppDelegate.h
//  Dominik
//
//  Created by amit varma on 02/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlVC.h"
#import "ActionPlanVC.h"
#import "PeopleVC.h"
#import "WetherVC.h"


#define KappDelgate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define KGoogleApiKey    @"AIzaSyAfJkNHU5FU_huXyeWksd2-xPgQNppm6dk"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
{
    UIStoryboard *storyboard;
    PeopleVC *ViewControllerObj;
    ActionPlanVC *FirstViewControllerObj;
    
    ControlVC *SecondViewControllerObj;
    WetherVC *ThirdViewControllerObj;
    
    UITabBarController *tabbar_controller;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)UINavigationController *navController;
@property(strong,nonatomic)UITabBarController *tabbar_controller;

-(void)tabbar;
-(void)makeRootView;
-(void)makeClenderAsRootView;
-(void)logout;
-(void)showAlertView:(NSString*)title with:(NSString*)message;


//DatabaseWorking

-(void)initialiseDataBase;
-(void)createTable:(NSString*)createquery;


@end

