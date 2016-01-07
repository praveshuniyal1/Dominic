//
//  ActiveDate.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "ActiveDate.h"
#import "ActiveDateCell.h"
#import "RecordingsVC.h"
#import "RecordingListVC.h"
#import "AppDelegate.h"
#import "RecordVC.h"
#import "AddSymptomes.h"
#import "FMDatabase.h"
#import "Constants.h"

@interface ActiveDate ()
{
    NSMutableArray *symptomArr;
    NSString *path;
    FMDatabase *database;
    NSMutableArray *selectArray;
    NSMutableArray *arr_symptomId;
    
    NSString *userId;
    NSString *selectDate;
    NSMutableDictionary *responceDic;
    NSMutableArray *responceArray;
    
    
    NSMutableArray *arrselect;
    NSInteger indexpath;
    
    NSMutableArray *weatherArray;
    UITapGestureRecognizer*tapgesture;
    NSString *currentDate;
    NSMutableArray *pastWeatherArr;
    
}

@property (nonatomic, strong) UIPopoverController *popOver;

@end

@implementation ActiveDate

- (void)viewDidLoad
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
    [super viewDidLoad];
    
    
}




-(void)viewWillAppear:(BOOL)animated
{
    weatherArray=[[NSMutableArray alloc]init];
    pastWeatherArr=[[NSMutableArray alloc]init];
    
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    currentDate=[[NSUserDefaults standardUserDefaults]valueForKey:@"CurrentDate"];
    
    
    responceDic=[[NSMutableDictionary alloc]init];
    responceArray=[[NSMutableArray alloc]init];
    lblDate.text=selectDate;
    [self reloadTable];
    
  //  [self getCurrentWeather];
    
    
   
    
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[[NSUserDefaults standardUserDefaults]objectForKey:@"dafault_selectDate"]];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era])
    
    {
       [self getCurrentWeather];
    }
    else
    {
        [self getWetherInfo:[self getDateFromString:[[NSUserDefaults standardUserDefaults]objectForKey:@"dafault_selectDate"]]];
        
        //[self pastDateWeather:[self getPastDateFromString:[[NSUserDefaults standardUserDefaults]objectForKey:@"dafault_selectDate"]]];
    }
    

}
-(void)getWetherInfo:(NSString*)Date
{
    [database open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM weatherTable where user_id='%@' AND date='%@'",userId,Date];
    FMResultSet *results = [database executeQuery:sql];
    
    while ([results next])
    {
        [pastWeatherArr addObject:[results resultDictionary]];
        [self loadSavedWeatherDetail:pastWeatherArr];
    }
    [results close];
    [database close];
}

-(void)reloadTable
{
    symptomArr=[[NSMutableArray alloc]init];
    selectArray=[[NSMutableArray alloc]init];
    arr_symptomId=[[NSMutableArray alloc]init];
    
    database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM AddSymptomTable WHERE user_id='%@'",userId];
    FMResultSet *results = [database executeQuery:sql];
    while ([results next])
    {
        [symptomArr addObject:[results resultDictionary]];
        [selectArray addObject:[[results resultDictionary]valueForKey:@"isActive"]];
        
    }
    [self addAction:symptomArr];
    
    [results close];
   
    symptomTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark  Get Weather Information

-(void)getCurrentWeather
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:KWeatherHourlyForcast parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *response = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
        responceArray=[response valueForKey:@"hourly_forecast"] ;
        [self loadWeatherDetail:responceArray];
       // NSLog(@"Weather Info=%@",responceArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
            }];
    
    
}
-(void)loadWeatherDetail:(NSMutableArray *)weatherArr
{
    lblMorning.text=[[[weatherArr objectAtIndex:6]valueForKey:@"temp"]valueForKey:@"english"];
   
    imgMor.image = [UIImage imageWithData:
                                       [NSData dataWithContentsOfURL:
                                        [NSURL URLWithString: [[weatherArr objectAtIndex:6]valueForKey:@"icon_url"]]]];
    NSString *morIconUrl=[[weatherArr objectAtIndex:6]valueForKey:@"icon_url"];
    
    lblAfternoon.text=[[[weatherArr objectAtIndex:13]valueForKey:@"temp"]valueForKey:@"english"];
    imgAft.image = [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString: [[weatherArr objectAtIndex:13]valueForKey:@"icon_url"]]]];
    
    NSString *aftIconUrl=[[weatherArr objectAtIndex:13]valueForKey:@"icon_url"];
    
    lblEveaning.text=[[[weatherArr objectAtIndex:18]valueForKey:@"temp"]valueForKey:@"english"];
    imgEve.image = [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString: [[weatherArr objectAtIndex:18]valueForKey:@"icon_url"]]]];
    
    NSString *eveIconUrl=[[weatherArr objectAtIndex:18]valueForKey:@"icon_url"];
    
    
    
    weatherArray=[[NSMutableArray alloc]init];
    
    database = [FMDatabase databaseWithPath:path];
    [database open];
    [database executeUpdate:@"create table weatherTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,user_id text,date text,morningTemp text,afternoonTemp text,eveaningTemp text,mornIcon text,afnIcon text,eveIcon text)"];
    NSString *sql = [NSString stringWithFormat:@"SELECT date FROM weatherTable WHERE date ='%@'",selectDate];
    
    FMResultSet *results = [database executeQuery:sql];
    if ([results next])
    {
       [results close];
    }
    else
    {
        
    
        
        NSString *query = [NSString stringWithFormat:@"insert into weatherTable(user_id,date,morningTemp,afternoonTemp,eveaningTemp,mornIcon,afnIcon,eveIcon) values ('%@','%@','%@','%@','%@','%@','%@','%@')",
                           userId,selectDate,lblMorning.text,lblAfternoon.text,lblEveaning.text,morIconUrl,aftIconUrl,eveIconUrl];
        [database executeUpdate:query];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM weatherTable where user_id='%@' and date='%@'",userId,selectDate];
        FMResultSet *results = [database executeQuery:sql];
        
        while ([results next])
        {
            [weatherArray addObject:[results resultDictionary]];
        }
        [self loadSavedWeatherDetail:weatherArray];
       
        [results close];
    }
    
    [database close];
   
    
}

-(void)loadSavedWeatherDetail:(NSMutableArray*)array
{
    
    lblMorning.text=[[array objectAtIndex:0]valueForKey:@"morningTemp"];
    
    imgMor.image = [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString: [[array objectAtIndex:0] valueForKey:@"mornIcon"]]]];
    
    
    lblAfternoon.text=[[array objectAtIndex:0] valueForKey:@"afternoonTemp"];
    imgAft.image = [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString: [[array objectAtIndex:0] valueForKey:@"afnIcon"]]]];
    
    
    
    lblEveaning.text=[[array objectAtIndex:0] valueForKey:@"eveaningTemp"];
    imgEve.image = [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString: [[array objectAtIndex:0] valueForKey:@"eveIcon"]]]];
    
    
    
    

    
}

-(void)pastDateWeather:(NSString*)date
{
    NSMutableString *apiUrl=[NSMutableString stringWithFormat:@"http://api.wunderground.com/api/8311da32aab281f6/history_%@/q/india/delhi.json",date];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:apiUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"JSON: %@", responseObject);
        
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary *response = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil];
        responceArray=[[response valueForKey:@"history"] valueForKey:@"observations"];
        [self loadPastDayWeather:responceArray];
        // NSLog(@"Weather Info=%@",responceArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
    }];

}
-(void)loadPastDayWeather:(NSMutableArray*)array
{
    lblMorning.text=[[array objectAtIndex:14]valueForKey:@"tempi"];
    
    
    imgMor.image = [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString:[NSString stringWithFormat:@"http://icons-ak.wxug.com/i/c/k/%@.gif",[[array objectAtIndex:14]valueForKey:@"icon"]] ]]];
    NSString *morIconUrl=[NSString stringWithFormat:@"http://icons-ak.wxug.com/i/c/k/%@.gif",[[array objectAtIndex:14]valueForKey:@"icon"]];
    
    lblAfternoon.text=[[array objectAtIndex:28]valueForKey:@"tempi"];
    imgAft.image = [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString: [NSString stringWithFormat:@"http://icons-ak.wxug.com/i/c/k/%@.gif",[[array objectAtIndex:28]valueForKey:@"icon"]]]]];
    
    NSString *aftIconUrl=[NSString stringWithFormat:@"http://icons-ak.wxug.com/i/c/k/%@.gif",[[array objectAtIndex:28]valueForKey:@"icon"]];
    
    lblEveaning.text=[[array objectAtIndex:40]valueForKey:@"tempi"];
    imgEve.image = [UIImage imageWithData:
                    [NSData dataWithContentsOfURL:
                     [NSURL URLWithString: [NSString stringWithFormat:@"http://icons-ak.wxug.com/i/c/k/%@.gif",[[array objectAtIndex:40]valueForKey:@"icon"]]]]];
    
    NSString *eveIconUrl=[NSString stringWithFormat:@"http://icons-ak.wxug.com/i/c/k/%@.gif",[[array objectAtIndex:40]valueForKey:@"icon"]];

    
}







#pragma mark -
#pragma mark   Other Action

- (IBAction)logoutAction:(id)sender
{
    AddSymptomes *recordingView = [self.storyboard instantiateViewControllerWithIdentifier:@"AddSymptomes"];
    [self.navigationController pushViewController:recordingView animated:YES];
    // [KappDelgate logout];
}

- (IBAction)backbtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)recordingsAction:(id)sender
{
    RecordVC *recordingView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordVC"];
    [self.navigationController pushViewController:recordingView animated:YES];
}

- (IBAction)editAction:(id)sender
{
    
}

- (IBAction)dailyReminderAction:(id)sender {
}



- (IBAction)nextDate:(id)sender
{
    
    
    NSDate *defaultcurrentDate=[[NSUserDefaults standardUserDefaults]valueForKey:@"dafault_selectDate"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:defaultcurrentDate];
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
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:defaultcurrentDate options:0];
   
    
    
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
    NSDate *defaultcurrentDate=[[NSUserDefaults standardUserDefaults]valueForKey:@"dafault_selectDate"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:defaultcurrentDate];
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
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:defaultcurrentDate options:0];
    
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

    
    
//    [[NSUserDefaults standardUserDefaults]setObject:[self getDateFromString:nextDate] forKey:@"selectDate"];
//    [[NSUserDefaults standardUserDefaults]setObject:nextDate forKey:@"dafault_selectDate"];
//    
//    lblDate.text=[self getDateFromString:nextDate];
//    [self viewWillAppear:YES];

}
-(NSString *)getDateFromString:(NSDate *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMM,yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:string];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}

-(NSString *)getPastDateFromString:(NSDate *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *stringFromDate = [formatter stringFromDate:string];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}


#pragma mark -
#pragma mark  TableView Datasource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return symptomArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"ActiveDateCell";
    ActiveDateCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[ActiveDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.lblSymptomes.text=[[symptomArr objectAtIndex:indexPath.row] valueForKey:@"symptomName"];
    [cell.btnSelect addTarget:self action:@selector(selectSymptom:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnSelect.tag=indexPath.row;
    
    if ([[[symptomArr valueForKey:@"isActive"] objectAtIndex:indexPath.row]isEqualToString:@"1"])
    {
        cell.btnSelect.selected=YES;
    }
    else{
        cell.btnSelect.selected=NO;
    }
    
   
    [cell.btnSelect1 setTitle:[[symptomArr valueForKey:@"painLavel"]objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    [cell.imageSymptom addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
    cell.imageSymptom.tag=indexPath.row;
    
    
    [cell.btnSelect1 addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnSelect1.tag=indexPath.row;
    
    
    if ([[[symptomArr valueForKey:@"image"]objectAtIndex:indexPath.row]isKindOfClass:[NSNull class]]||[[[symptomArr valueForKey:@"image"]objectAtIndex:indexPath.row] isEqualToString:@"<null>"])
    {
        UIImage *btnImage = [UIImage imageNamed:@"people-img"];
        [cell.imageSymptom setImage:btnImage forState:UIControlStateNormal];
    }
    else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
       NSString* str_offline=[self documentsPathForFileName:[[symptomArr valueForKey:@"image"]objectAtIndex:indexPath.row]];
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:[[symptomArr valueForKey:@"image"]objectAtIndex:indexPath.row]] lastPathComponent]]];
        
        [cell.imageSymptom setImage:[UIImage imageWithContentsOfFile:getImagePath] forState:UIControlStateNormal];
       
    }
    
  
    return cell;
}





#pragma mark -
#pragma mark  Selection Action

- (IBAction)selectClicked:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:symptomTable];
    NSIndexPath *indexPath = [symptomTable indexPathForRowAtPoint:buttonPosition];
    
    UITableViewCell *cell = [symptomTable cellForRowAtIndexPath:indexPath];
    
    
    
    NSLog(@"%ld",(long)sender.tag);
    arrselect = [[NSMutableArray alloc] init];
    UIButton *btn=[[UIButton alloc]init];
    if (IS_IPAD)
    {
        btn.frame=CGRectMake(673, (cell.frame.size.height*sender.tag+46)-185, 64, 200);
        btn.tag=sender.tag;
       
    }
    else
    {
        btn.frame=CGRectMake(232, (cell.frame.size.height*sender.tag+46)-200, 64, 200);
        btn.tag=sender.tag;
    }

   
    
    
    CGFloat f = 100;
    NSArray *tAry=[[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
    if (dropDown==nil) {
        
    dropDown = [[NIDropDown alloc]showDropDown:btn :&f :tAry :nil :@"down"];
    dropDown.delegate = self;
    [symptomTable addSubview:dropDown];
    [symptomTable bringSubviewToFront:dropDown];
    }
    else{
        [dropDown hideDropDown:btn];
        [self rel];
    }
    
 }

#pragma mark -
#pragma mark  NIDropDown Delegate

- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:symptomTable];
    NSIndexPath *indexPath = [symptomTable indexPathForRowAtPoint:buttonPosition];
    NSLog(@"%d",indexPath.row);
    
    UITableViewCell *cell = [symptomTable cellForRowAtIndexPath:indexPath];
    
   
    
    
    NSArray *subviews;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        subviews = cell.contentView.subviews;
    else
        subviews = cell.subviews;
    
    for(id aView in subviews)
    {
        if([aView isKindOfClass:[UIButton class]])
        {
                NSArray *tAry=[[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
                NSLog(@"%ld",[[NSUserDefaults standardUserDefaults]integerForKey:@"indexPath"]);
               [aView setTitle:[tAry objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"indexPath"]] forState: UIControlStateNormal];
            
            
            
            [database open];
            NSString *sql = [NSString stringWithFormat:@"UPDATE SymptomTable SET painLavel='%@' WHERE id='%@' AND date='%@'",[tAry objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"indexPath"]],[arr_symptomId objectAtIndex:indexPath.row],selectDate];
            BOOL success = [database executeUpdate:sql];
            if(success)
            {
                [self setPainLavel];
            }
            [database close];
            

            
            
            
        }
   }
    
    [self rel];
}


-(void)rel
{
    
    dropDown = nil;
}
-(void)setPainLavel
{
    symptomArr=[[NSMutableArray alloc]init];
     [database open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SymptomTable WHERE date ='%@'AND isHidden='%@'",selectDate,@"0"];
    
    FMResultSet *results = [database executeQuery:sql];
    while ([results next])
    {
        [symptomArr addObject:[results resultDictionary]];
        [arr_symptomId addObject:[[results resultDictionary]valueForKey:@"id"]];
    }
    [results close];
    [database close];
    [symptomTable reloadData];
}




#pragma mark -
#pragma mark  GetDocument directory Path

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}


#pragma mark -
#pragma mark  Database working

-(void)selectSymptom:(UIButton*)sender
{
    database = [FMDatabase databaseWithPath:path];
    [database open];
    if (sender.selected)
    {
        for (int i=0; i<arr_symptomId.count; i++)
        {
            [database open];
            NSString *sql = [NSString stringWithFormat:@"UPDATE SymptomTable SET isActive='%@' WHERE id='%@' AND date='%@'",@"0",[arr_symptomId objectAtIndex:sender.tag],selectDate];
            BOOL success = [database executeUpdate:sql];
            if(success)
            {
                [self reloadTable];
            }

        }
        
    }
    else
    {
        
        
        
        BOOL isPainLavel=[self getPainLavel:sender];
        
        if (isPainLavel==YES)
        {
            for (int i=0; i<arr_symptomId.count; i++)
            {
                database = [FMDatabase databaseWithPath:path];
                [database open];
                
                //[self updateTrapInDatabase:database Array:arr_symptomId trapID:i];
                
                NSString *sql = [NSString stringWithFormat:@"UPDATE SymptomTable SET isActive='%@' WHERE id='%@' AND date='%@'",@"0",[arr_symptomId objectAtIndex:i],selectDate];
                BOOL success = [database executeUpdate:sql];
                if(success)
                {
                    [self reloadTable];
                }
                [database close];
                
            }

            
            
            database = [FMDatabase databaseWithPath:path];
            [database open];
            
            NSString *sql1 = [NSString stringWithFormat:@"UPDATE SymptomTable SET isActive='%@' WHERE id='%@' AND date='%@'",@"1",[arr_symptomId objectAtIndex:sender.tag],selectDate];
            BOOL success1 = [database executeUpdate:sql1];
            if(success1)
            {
                [self reloadTable];
            }
            [database close];

        }
        else
        {
            [KappDelgate showAlertView:nil with:@"Please fill pain lavel"];
        }
        
        
    }
   
    [database close];
    
}

- (void)updateTrapInDatabase:(FMDatabase *)db Array:(NSMutableArray*)array trapID:(int)ID
{
  
}



-(BOOL)getPainLavel:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:symptomTable];
    NSIndexPath *indexPath = [symptomTable indexPathForRowAtPoint:buttonPosition];
    UITableViewCell *cell = [symptomTable cellForRowAtIndexPath:indexPath];
    
    NSArray *subviews;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        subviews = cell.contentView.subviews;
    else
        subviews = cell.subviews;
    
    for(id aView in subviews)
    {
        if([aView isKindOfClass:[UIButton class]])
        {
            database = [FMDatabase databaseWithPath:path];
            [database open];
            
            NSString *sql = [NSString stringWithFormat:@"SELECT painLavel FROM SymptomTable WHERE  id='%@' AND date ='%@'AND isHidden='%@'",[arr_symptomId objectAtIndex:indexPath.row],selectDate,@"0"];
            
            FMResultSet *results = [database executeQuery:sql];
            if([results next])
            {
                NSMutableArray *arr=[[NSMutableArray alloc]init];
                [arr addObject:[results resultDictionary]];
                NSString *painlavel=[[arr objectAtIndex:0]valueForKey:@"painLavel"];
                if ([painlavel isEqualToString:@"0"])
                {
                    [results close];
                    [database close];
                    return NO;
                }
                else{
                    [results close];
                    [database close];
                    return YES;
                }
            }
        }
    }

    
    return NO;
}







- (IBAction)addAction:(NSMutableArray*)array
{
    symptomArr=[[NSMutableArray alloc]init];
    
    database = [FMDatabase databaseWithPath:path];
    [database open];
    [database executeUpdate:@"create table SymptomTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,user_id text,date text,symptomName text,image text,isActive text,isHidden text,painLavel text)"];
    
    
    for (int i=0; i<array.count; i++)
    {
        NSString *searchString = [[array valueForKey:@"symptomName"] objectAtIndex:i];
        NSString *likeParameter = [NSString stringWithFormat:@"%%%@%%", searchString];
        NSString *sql = [NSString stringWithFormat:@"SELECT symptomName FROM SymptomTable WHERE symptomName ='%@' AND date ='%@'",searchString,selectDate];
        
        FMResultSet *results = [database executeQuery:sql, likeParameter];
        if([results next])
        {
            NSString *sql = [NSString stringWithFormat:@"UPDATE SymptomTable SET isHidden='%@' WHERE symptomName='%@' AND date='%@'",[[array objectAtIndex:i] valueForKey:@"isHidden"],[[array objectAtIndex:i] valueForKey:@"symptomName"],selectDate];
            BOOL success = [database executeUpdate:sql];
            if(success)
            {
                [results close];
            }

            
        }
        else
        {
//            if ([currentDate isEqualToString:selectDate])
//            {
                NSString *query = [NSString stringWithFormat:@"insert into SymptomTable(user_id,symptomName,isActive,date,image,isHidden,painLavel) values ('%@','%@','%@','%@','%@','%@','%@')",
                                   userId,[[array valueForKey:@"symptomName"] objectAtIndex:i],@"0",selectDate,[[array valueForKey:@"image"] objectAtIndex:i],@"0",@"0"];
                [database executeUpdate:query];
                
                [database open];
                NSString *searchString = [[array valueForKey:@"symptomName"] objectAtIndex:i];
                NSString *likeParameter = [NSString stringWithFormat:@"%%%@%%", searchString];
                NSString *sql = [NSString stringWithFormat:@"SELECT symptomName FROM SymptomTable WHERE symptomName ='%@' AND date ='%@'",searchString,selectDate];
                
                FMResultSet *results = [database executeQuery:sql, likeParameter];
                if([results next])
                {
                    NSString *sql = [NSString stringWithFormat:@"UPDATE SymptomTable SET isHidden='%@' WHERE symptomName='%@' AND date='%@'",[[array objectAtIndex:i] valueForKey:@"isHidden"],[[array objectAtIndex:i] valueForKey:@"symptomName"],selectDate];
                    BOOL success = [database executeUpdate:sql];
                    if(success)
                    {
                        [results close];
                    }
                    
                    
                }

                
//            }
//            else
//            {
//                [KappDelgate showAlertView:@"Message" with:@"No data found"];
//                
//            }
            

        }
        
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SymptomTable WHERE date ='%@'AND isHidden='%@'",selectDate,@"0"];
    
    FMResultSet *results = [database executeQuery:sql];
    while ([results next])
    {
        [symptomArr addObject:[results resultDictionary]];
        [arr_symptomId addObject:[[results resultDictionary]valueForKey:@"id"]];
    }
    [results close];
    [database close];
    [symptomTable reloadData];
    
    
}




-(void)selectImage:(UIButton*)sender
{
    indexpath=sender.tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Face for Perform Dance step"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Select from Library", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}



#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int i = buttonIndex;
    switch(i)
    {
        case 0:
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{}];
        }
            break;
        case 1:
        {
            
            UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
            picker.delegate = self;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //your code
                    
                    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
                    [popover presentPopoverFromRect:CGRectMake(450.0f, 825.0f, 10.0f, 10.0f) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    self.popOver = popover;
                }];
               
                
                
            } else
            {
                 picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:^{}];
            }

        }
        default:
            // Do Nothing.........
            break;
    }
}
#pragma mark -
#pragma - mark Selecting Image from Camera and Library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *selectedImage;
    NSURL * mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
    
    if (mediaUrl == nil) {
        
        selectedImage = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        if (selectedImage == nil) {
            
            selectedImage= (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
            
            
            CGRect rect = CGRectMake(0,0,200,200);
            UIGraphicsBeginImageContext( rect.size );
            [selectedImage drawInRect:rect];
            UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSData *profile_image_data = UIImagePNGRepresentation(picture1);
            
            ///////////////////////////////////////Store image in document directory
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
            NSString*str_date=[format stringFromDate:[NSDate date]];
            NSString *strImagePath=[NSString stringWithFormat:@"%@.png",str_date];
            
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            NSString *filePath = [documentsPath stringByAppendingPathComponent:strImagePath];
            [profile_image_data writeToFile:filePath atomically:YES];
            
            
          NSString *  str_offline=[self documentsPathForFileName:strImagePath];
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[@"/" stringByAppendingString:[[self documentsPathForFileName:strImagePath] lastPathComponent]]];
            // UIImage *img=[UIImage imageWithContentsOfFile:getImagePath];
            
            
            [database open];
            NSString *query = [NSString stringWithFormat:@"UPDATE SymptomTable SET image='%@' where user_id='%@' AND symptomName='%@' AND date='%@'",
                               strImagePath,userId,[[symptomArr objectAtIndex:indexpath] valueForKey:@"symptomName"],selectDate];
            BOOL results = [database executeUpdate:query];
            
            if (results)
            {
                symptomArr=[NSMutableArray new];
                FMResultSet *results = [database executeQuery:@"SELECT * FROM SymptomTable"];
                while ([results next])
                {
                    [symptomArr addObject:[results resultDictionary]];
                }
                [symptomTable reloadData];
                [results close];
            }
            
            NSLog(@"Original image picked.");
        }
        else {
            NSLog(@"Edited image picked.");
        }
    }
    [picker dismissModalViewControllerAnimated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissModalViewControllerAnimated:YES];
}








@end
