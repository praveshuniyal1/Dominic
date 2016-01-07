//
//  CalenderVC.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "CalenderVC.h"
#import "ActiveDate.h"
#import "LGCalendar.h"
#import "DetailVC.h"
#import "AppDelegate.h"


@interface CalenderVC ()<UITextFieldDelegate, LGCalendarDelegate>

@property (nonatomic, strong) LGCalendar *LGCalendar;

@end

@implementation CalenderVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    LGCalendar *calendar = [[LGCalendar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 240)];
    [self.view addSubview:calendar];
    calendar.delegate = self;
    self.LGCalendar = calendar;

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LGCalendar:(LGCalendar *)calendar didSelectDate:(NSDate *)selectDate
{
    NSLog(@"select date:%@", selectDate);
    
    NSDate *currentDate=[NSDate date];
    [[NSUserDefaults standardUserDefaults]setObject:[self getDateFromString:currentDate] forKey:@"CurrentDate"];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString * date=[dateFormatter stringFromDate:selectDate];
    
    
    id object=selectDate;
    if (object)
    {
        if ([KappDelgate isCurrentDate:date])
        {
            DetailVC *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
            [[NSUserDefaults standardUserDefaults]setObject:[self getDateFromString:selectDate] forKey:@"selectDate"];
            [[NSUserDefaults standardUserDefaults]setObject:selectDate forKey:@"dafault_selectDate"];
            [self.navigationController pushViewController:detailView animated:YES];
        }
        else
        {
            if ([KappDelgate isSymptomFoundOnDate:date])
            {
                DetailVC *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
                [[NSUserDefaults standardUserDefaults]setObject:[self getDateFromString:selectDate] forKey:@"selectDate"];
                [[NSUserDefaults standardUserDefaults]setObject:selectDate forKey:@"dafault_selectDate"];
                [self.navigationController pushViewController:detailView animated:YES];
            }
            else
            {
                [KappDelgate showAlertView:nil with:@"No event found"];
            }
            
        }
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

- (IBAction)click
{
    [self.LGCalendar setCurrentDate:[NSDate date]];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)homeAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutAction:(id)sender
{
    [KappDelgate logout];
}
@end
