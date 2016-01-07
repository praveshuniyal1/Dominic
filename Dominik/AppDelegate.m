//
//  AppDelegate.m
//  Dominik
//
//  Created by amit varma on 02/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "CalenderVC.h"
#import "FMDatabase.h"
#import "LocationManager.h"
#import "Constants.h"





@interface AppDelegate ()
{
    NSMutableArray *tabbar_array;
    UINavigationController *navigation_app_delegate;
    NSString *path;
    FMDatabase *database;


}
@end

@implementation AppDelegate
@synthesize tabbar_controller;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[LocationManager locationInstance]getcurrentLocation];
    tabbar_array=[[NSMutableArray alloc]init];
    tabbar_controller=[[UITabBarController alloc]init];
   
    [self tabbar];
    
    
    if (IS_IPAD)
    {
        ViewController *loginController=[[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"]; //or the homeController
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
        self.window.rootViewController=navController;

    }
    else{
        ViewController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"]; //or the homeController
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
        self.window.rootViewController=navController;

    }
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:94/255.0f green:165/255.0f blue:43/255.0f alpha:1.0f]];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f]
       } forState:UIControlStateNormal];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1],
       NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f]
       } forState:UIControlStateSelected];
    
    
    return YES;
}
#pragma DataBase working
-(void)initialiseDataBase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
}
-(void)createTable:(NSString*)createquery
{
    database = [FMDatabase databaseWithPath:path];
    [database open];
    [database executeUpdate:createquery];//@"create table UserPassword(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,name text,password text)"
}

#pragma other working
-(void)makeRootView
{
    [tabbar_controller.tabBar setBackgroundImage:[UIImage imageNamed:@"Rectangle-2"]];

    //[[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:(55.0/255.0) green:(47.0/255.0) blue:(45.0/255.0) alpha:1]];
    self.window.rootViewController=tabbar_controller;
    
}

-(void)makeClenderAsRootView
{
    
    if (IS_IPAD)
    {
        CalenderVC *calenderController=[[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"CalenderVC"]; //or the homeController
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:calenderController];
        self.window.rootViewController=navController;
    }
    else{
        CalenderVC *calenderController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CalenderVC"]; //or the homeController
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:calenderController];
        self.window.rootViewController=navController;
    }
   
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
   
}
-(void)logout
{
    if (IS_IPAD)
    {
        ViewController *loginController=[[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
          UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
        self.window.rootViewController=navController;
    }
    else{
         ViewController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"]; //or the homeController
          UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
        self.window.rootViewController=navController;
    }
   
  
    
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
   
}
-(void)tabbar
{
    if (IS_IPAD)
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
    }
    else{
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    
    
    ViewControllerObj = [storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    FirstViewControllerObj=[storyboard instantiateViewControllerWithIdentifier:@"SymptomList"];
    SecondViewControllerObj=[storyboard instantiateViewControllerWithIdentifier:@"WhatsPlanVC"];
    ThirdViewControllerObj=[storyboard instantiateViewControllerWithIdentifier:@"SymptomesVC"];
   
    
    
    UINavigationController *Viewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:ViewControllerObj];
    [Viewcontroller_navigation.tabBarItem setImage: [ Viewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"calendarTab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    Viewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"calendericon1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Viewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    Viewcontroller_navigation.title=@"Question";
    [tabbar_array addObject:Viewcontroller_navigation];
    
    
    UINavigationController *FirstViewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:FirstViewControllerObj];
    [FirstViewcontroller_navigation.tabBarItem setImage: [ FirstViewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"data"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    FirstViewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"actionicon1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    FirstViewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    FirstViewcontroller_navigation.title=@"Action";
    [tabbar_array addObject:FirstViewcontroller_navigation];
    
    
    UINavigationController *SecondViewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:SecondViewControllerObj];
    [SecondViewcontroller_navigation.tabBarItem setImage: [ SecondViewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"chronometer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    SecondViewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"controlicon1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    SecondViewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    SecondViewcontroller_navigation.title=@"Control";
    [tabbar_array addObject:SecondViewcontroller_navigation];
    
    
    UINavigationController *ThirdViewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:ThirdViewControllerObj];
    [ThirdViewcontroller_navigation.tabBarItem setImage: [ ThirdViewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"business"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    ThirdViewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"databaseicon1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ThirdViewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
     ThirdViewcontroller_navigation.title=@"Database";
    [tabbar_array addObject:ThirdViewcontroller_navigation];
    
    
    
    Viewcontroller_navigation.navigationBarHidden=YES;
    FirstViewcontroller_navigation.navigationBarHidden=YES;
    SecondViewcontroller_navigation.navigationBarHidden=YES;
    ThirdViewcontroller_navigation.navigationBarHidden=YES;
    
    tabbar_controller.delegate=self;
    [tabbar_controller setViewControllers:tabbar_array animated:YES];
    
   
    
}
-(BOOL)isCurrentDate:(NSString*)date
{
    NSDate *defaultcurrentDate=[NSDate date];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString * currentDate=[dateFormatter stringFromDate:defaultcurrentDate];
    if ([currentDate isEqualToString:date])
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    return YES;
}
-(BOOL)isSymptomFoundOnDate:(NSString*)selectDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate * date=[dateFormatter dateFromString:selectDate];
    
    [self initialiseDataBase];
    [database open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SymptomTable WHERE date ='%@'AND isHidden='%@'",[self getDateFromString:date],@"0"];
    
    FMResultSet *results = [database executeQuery:sql];
    if  ([results next])
    {
        [results close];
        [database close];
        return YES;

    }
    else{
        return NO;
    }
    
   
    return YES;
}

-(NSString *)getDateFromString:(NSDate *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMM,yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:string];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}

-(void)showAlertView:(NSString*)title with:(NSString*)message
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
