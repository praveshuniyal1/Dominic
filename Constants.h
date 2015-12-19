//
//  Constant.h
//  BuddySystem
//
//  Created by Jitendra on 12/01/15.
//  Copyright (c) 2015 Webastral. All rights reserved.
//

#ifndef BuddySystem_Constants_h
#define BuddySystem_Constants_h

#define KappDelgate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#define KWeatherKey @"8311da32aab281f6"


//#define KWetherCurrentDayApi @"http://api.openweathermap.org/data/2.5/weather?APPID=d709f680c88e44bbe2969c2b5d86629f&q=india,chandigarh"
#define KWeatherForeCast   @"http://api.wunderground.com/api/8311da32aab281f6/forecast/q/india/delhi.json"
#define KWeatherHourlyForcast  @"http://api.wunderground.com/api/8311da32aab281f6/hourly/q/30.7399738,76.7567368.json"
#define KWetherCurrentDayApi @"http://api.wunderground.com/api/8311da32aab281f6/conditions/q/30.7399738,76.7567368.json"
#define KWetherNext10dayApi  @"http://api.wunderground.com/api/8311da32aab281f6/forecast10day/q/30.7399738,76.7567368.json"
#define KWetherPastDayApi    @"http://api.wunderground.com/api/8311da32aab281f6/history_20151213/q/india/delhi.json"

#define KgoogleApiKey        @"AIzaSyBewjXe0h5_3t1v9ycpf5RC9i_pAN6Mj8g"


//expiry_param= Now=0 , Today=1 , This weakend=3 ,Anytime=4 ,Other=5
typedef enum : NSUInteger
{
    Now=0,
    Today,
    Thisweakend,
    Anytime,
    Other,
   
    
} expiry_param;

#define HorizontalBarMode  0
#define RingBarMode        1
#define piechartBarMode    2






#define KBaseUrl               @"http://dev414.trigma.us/Buddy/webs/"

#define Ksignup                @"registeruser?"


#define KCloseAccount          @"delete_user?"
#define KLogout                @"online?"





#endif
