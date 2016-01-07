//
//  DetailVC.m
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "DetailVC.h"
#import "SymptomList.h"
#import "FoodDrinkVC.h"
#import "LocationVC.h"
#import "PeopleVC.h"
#import "AppDelegate.h"
#import "ActiveDate.h"
#import "FurtherQuestionVC.h"
#import "FMDatabase.h"
#import "QuestionFurtherVC.h"


@interface DetailVC ()
{
    NSMutableArray *foodArr;
    NSString *path;
    FMDatabase *database;
    NSString *currentDate;

}

@end

@implementation DetailVC
@synthesize strDate;


- (void)viewDidLoad
{
    [super viewDidLoad];
     [KappDelgate makeRootView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSString *selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    currentDate=[[NSUserDefaults standardUserDefaults]valueForKey:@"CurrentDate"];
    
     lblDate.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectDate"]];
    
    
    NSString *sqlsym = [NSString stringWithFormat:@"SELECT * FROM SymptomTable WHERE user_id='%@' AND date='%@'",userId,selectDate];
    FMResultSet *symResults = [database executeQuery:sqlsym];
    if([symResults next])
    {
        btnSymptomes.selected=YES;
       lblSymptomes.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    }
    else{
        btnSymptomes.selected=NO;
        lblSymptomes.textColor=[UIColor grayColor];
    }
       [symResults close];

    
    NSString *sql = [NSString stringWithFormat:@"SELECT foodName FROM AddFoodTbl where user_id='%@' and date='%@'",userId,selectDate];
    FMResultSet *foodResults = [database executeQuery:sql];
   
    if ([foodResults next])
    {
        btnFoodAndDrink.selected=YES;
        lblFoodDrink.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    }
    else{
        btnFoodAndDrink.selected=NO;
        lblFoodDrink.textColor=[UIColor grayColor];
    }
    [foodResults close];
    
    
    NSString *sqlPeople = [NSString stringWithFormat:@"SELECT peopleName FROM peopleTbl where user_id='%@' and date='%@'",userId,selectDate];
    FMResultSet *peopleResults = [database executeQuery:sqlPeople];
    
    if ([peopleResults next])
    {
        btnPeople.selected=YES;
        lblPeople.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    }
    else{
        btnPeople.selected=NO;
        lblPeople.textColor=[UIColor grayColor];
    }
    [peopleResults close];
    
    
    NSString *sqlLocation = [NSString stringWithFormat:@"SELECT locationName FROM locationTbl where user_id='%@' and date='%@'",userId,selectDate];
    FMResultSet *locationResults = [database executeQuery:sqlLocation];
    
    if ([locationResults next])
    {
        btnLOcation.selected=YES;
        lblLocation.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    }
    else{
        btnLOcation.selected=NO;
        lblLocation.textColor=[UIColor grayColor];
    }
    [locationResults close];
    
    NSString *sqlQuestion = [NSString stringWithFormat:@"SELECT * FROM questionTbl where user_id='%@' and date='%@'",userId,selectDate];
    FMResultSet *QuestionResults = [database executeQuery:sqlQuestion];
    
    if ([QuestionResults next])
    {
        btnQuestion.selected=YES;
        lblQuestion.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    }
    else{
        btnQuestion.selected=NO;
        lblQuestion.textColor=[UIColor grayColor];
    }
    [QuestionResults close];


  
}

- (IBAction)nextDate:(id)sender
{
    NSDate *currentDate1=[[NSUserDefaults standardUserDefaults]valueForKey:@"dafault_selectDate"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:currentDate1];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay];
    [components setMonth:theMonth];
    [components setYear:theYear];
    NSDate *thisDate = [gregorian dateFromComponents:components];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:currentDate1 options:0];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString * date=[dateFormatter stringFromDate:nextDate];
    
    if ([KappDelgate isSymptomFoundOnDate:date])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[self getDateFromString:nextDate] forKey:@"selectDate"];
        [[NSUserDefaults standardUserDefaults]setObject:nextDate forKey:@"dafault_selectDate"];
        lblDate.text=[self getDateFromString:nextDate];
        [self viewWillAppear:YES];
    }
    else
    {
        [KappDelgate showAlertView:nil with:@"No event found"];
    }

    

}

- (IBAction)previousDate:(id)sender
{
    NSDate *currentDate1=[[NSUserDefaults standardUserDefaults]valueForKey:@"dafault_selectDate"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:currentDate1];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay];
    [components setMonth:theMonth];
    [components setYear:theYear];
    NSDate *thisDate = [gregorian dateFromComponents:components];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-1];
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:currentDate1 options:0];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString * date=[dateFormatter stringFromDate:nextDate];
    
    if ([KappDelgate isSymptomFoundOnDate:date])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[self getDateFromString:nextDate] forKey:@"selectDate"];
        [[NSUserDefaults standardUserDefaults]setObject:nextDate forKey:@"dafault_selectDate"];
        lblDate.text=[self getDateFromString:nextDate];
        [self viewWillAppear:YES];
    }
    else
    {
        [KappDelgate showAlertView:nil with:@"No event found"];
    }

    
}
-(NSString *)getDateFromString:(NSDate *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMM,yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:string];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)symptomesAction:(id)sender
{
    [btnSymptomes setSelected:YES];
    lblSymptomes.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    ActiveDate *activeView = [self.storyboard instantiateViewControllerWithIdentifier:@"ActiveDate"];
    [self.navigationController pushViewController:activeView animated:YES];

}

- (IBAction)foodDrinkAction:(id)sender
{
    [btnFoodAndDrink setSelected:YES];
    
    lblFoodDrink.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    FoodDrinkVC *foodView = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodDrinkVC"];
    [self.navigationController pushViewController:foodView animated:YES];
}

- (IBAction)locationAction:(id)sender
{
    [btnLOcation setSelected:YES];
    
    lblLocation.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    LocationVC *locationView = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationVC"];
    [self.navigationController pushViewController:locationView animated:YES];
}

- (IBAction)peopleAction:(id)sender
{
    [btnPeople setSelected:YES];
    
    lblPeople.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    PeopleVC *peopleView = [self.storyboard instantiateViewControllerWithIdentifier:@"PeopleVC"];
    [self.navigationController pushViewController:peopleView animated:YES];
}


- (IBAction)questionAction:(id)sender
{
    [btnQuestion setSelected:YES];
    
    lblQuestion.textColor=[UIColor colorWithRed:(109.0/255.0) green:(161.0/255.0) blue:(63.0/255.0) alpha:1];
    QuestionFurtherVC *furtherView = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionFurtherVC"];
    [self.navigationController pushViewController:furtherView animated:YES];

}

- (IBAction)backBtnAction:(id)sender
{
    [btnSymptomes setSelected:NO];
    [btnFoodAndDrink setSelected:NO];
    [btnLOcation setSelected:NO];
    [btnQuestion setSelected:NO];
    [btnPeople setSelected:NO];
    
    
    
    [KappDelgate makeClenderAsRootView];
    
}

- (IBAction)logoutBtnAction:(id)sender
{
     [KappDelgate logout];
}
@end
