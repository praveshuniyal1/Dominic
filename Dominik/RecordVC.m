//
//  RecordVC.m
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "RecordVC.h"
#import "RecordCell.h"
#import "AppDelegate.h"
#import "FMDatabase.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface RecordVC ()
{
    NSMutableDictionary*  recordSetting ;
    NSMutableDictionary*  editedObject ;
    NSString* recorderFilePath;
    AVAudioRecorder* recorder ;
    AVAudioPlayer *audioPlayerl;
    NSString *path;
    NSString *recordPath;
    FMDatabase *database;
    NSString *userId;
    NSString *selectDate;
    NSMutableArray *recordArr;
}

@end

@implementation RecordVC

@synthesize recorder,recorderSettings,recorderFilePath;
@synthesize audioPlayer,audioFileName;


- (void)viewDidLoad {
    [super viewDidLoad];
    recordArr=[[NSMutableArray alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    recordArr=[NSMutableArray new];
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    lblDate.text=selectDate;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM recordTbl where user_id='%@' and date='%@'",userId,selectDate];
    FMResultSet *recordResults = [database executeQuery:sql];
    
    while([recordResults next])
    {
        [recordArr addObject:[recordResults resultDictionary]];
    }
    
    [tblRecord reloadData];
    [recordResults close];
}




#pragma mark - Audio Recording
- (IBAction)startRecording:(id)sender
{
    if (btnStartRecording.isSelected==NO)
    {
        btnStartRecording.alpha=0.5;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
        if(err)
        {
            NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
            return;
        }
        [audioSession setActive:YES error:&err];
        err = nil;
        if(err)
        {
            NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
            return;
        }
        
        recorderSettings = [[NSMutableDictionary alloc] init];
        [recorderSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [recorderSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recorderSettings setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        [recorderSettings setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recorderSettings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recorderSettings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        
        // Create a new audio file
        
        
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        NSString*str_date=[format stringFromDate:[NSDate date]];
        recordPath=[NSString stringWithFormat:@"%@.caf",str_date];
        
        recorderFilePath = [NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, recordPath] ;
        
        
        NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
        err = nil;
        recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recorderSettings error:&err];
        if(!recorder){
            NSLog(@"recorder: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Warning" message: [err localizedDescription] delegate: nil
                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        //prepare to record
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        
        BOOL audioHWAvailable = audioSession.inputIsAvailable;
        if (! audioHWAvailable) {
            UIAlertView *cantRecordAlert =
            [[UIAlertView alloc] initWithTitle: @"Warning"message: @"Audio input hardware not available"
                                      delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [cantRecordAlert show];
            return;
        }
        
        // start recording
        [recorder recordForDuration:(NSTimeInterval) 60];//Maximum recording time : 60 seconds default
        
        [btnStartRecording setSelected:YES];
        NSLog(@"Recroding Started");
 
    }
    else if (btnStartRecording.isSelected==YES)
    {
        btnStartRecording.alpha=1.0;
        [btnStartRecording setSelected:NO];
        [self stopRecording:nil];
    }
}

- (IBAction)stopRecording:(id)sender
{
    [recorder stop];
    [self addAction:nil];
    NSLog(@"Recording Stopped");
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
}


#pragma mark - Audio Playing
- (IBAction)startPlaying:(id)sender
{
    NSLog(@"playRecording");
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, recordPath]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    NSLog(@"playing");
}
- (IBAction)stopPlaying:(id)sender
{
    [audioPlayer stop];
    NSLog(@"stopped");
}


- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:name];
}

#pragma database work

- (IBAction)addAction:(id)sender
{
    
    recordArr=[NSMutableArray new];
    database = [FMDatabase databaseWithPath:path];
    [database open];
    [database executeUpdate:@"create table recordTbl(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,user_id text,recordName text,date text,recordTitle text)"];
    
     NSString *sql = [NSString stringWithFormat:@"SELECT max(recordTitle) as last FROM recordTbl where user_id='%@' and date='%@'",userId,selectDate];
    
    FMResultSet *results = [database executeQuery:sql];
    while ([results next])
    {
        NSLog(@"%@",[results resultDictionary]) ;
        if ([[[results resultDictionary] valueForKey:@"last"]isKindOfClass:[NSNull class]])
        {
            NSString *query = [NSString stringWithFormat:@"insert into recordTbl(user_id,recordName,date,recordTitle) values ('%@','%@','%@','%@')",
                               userId,recordPath,selectDate,@"Recording Value 1"];
            [database executeUpdate:query];
        }
        else
        {
            NSString *str = [[results resultDictionary] valueForKey:@"last"];
            
            str = [str stringByReplacingOccurrencesOfString:@"Recording Value "
                                                 withString:@""];
            
            int count=[str intValue];
            NSString *recordTitle=[NSString stringWithFormat:@"Recording Value %d",count+1];
            NSString *query = [NSString stringWithFormat:@"insert into recordTbl(user_id,recordName,date,recordTitle) values ('%@','%@','%@','%@')",
                               userId,recordPath,selectDate,recordTitle];
            [database executeUpdate:query];

        }
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM recordTbl where user_id='%@' and date='%@'",userId,selectDate];
        FMResultSet *sqlresults = [database executeQuery:sql];
        
        while ([sqlresults next])
        {
            [recordArr addObject:[sqlresults resultDictionary]];
        }
        [database close];
        
        [sqlresults close];
        [results close];
        [tblRecord reloadData];
    }
    
}





///////////////////////////////////////


- (IBAction)nextDate:(id)sender
{
    NSDate *currentDate=[[NSUserDefaults standardUserDefaults]valueForKey:@"dafault_selectDate"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:currentDate];
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
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:currentDate options:0];
    [[NSUserDefaults standardUserDefaults]setObject:[self getDateFromString:nextDate] forKey:@"selectDate"];
    [[NSUserDefaults standardUserDefaults]setObject:nextDate forKey:@"dafault_selectDate"];
    lblDate.text=[self getDateFromString:nextDate];
    [self viewWillAppear:YES];
}

- (IBAction)previousDate:(id)sender
{
    NSDate *currentDate=[[NSUserDefaults standardUserDefaults]valueForKey:@"dafault_selectDate"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:currentDate];
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
    NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:currentDate options:0];
    [[NSUserDefaults standardUserDefaults]setObject:[self getDateFromString:nextDate] forKey:@"selectDate"];
    [[NSUserDefaults standardUserDefaults]setObject:nextDate forKey:@"dafault_selectDate"];
    lblDate.text=[self getDateFromString:nextDate];
    [self viewWillAppear:YES];
    
}
-(NSString *)getDateFromString:(NSDate *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMM,yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:string];
    
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}





- (IBAction)logoutAction:(id)sender{
     [KappDelgate logout];
}

- (IBAction)backbtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)recordDeleteAction:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Do you want to delete this records" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma tableview data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return recordArr.count;    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"RecordCell";
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[RecordCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:MyIdentifier];
    }
    cell.lblRecordName.text=[[recordArr valueForKey:@"recordTitle"] objectAtIndex:indexPath.row];
    cell.lblTime.text=[[recordArr valueForKey:@"recordName"] objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    RecordingsVC *recordView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordingsVC"];
    recordView.recordDic=[recordArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:recordView animated:YES];
    
    
}


@end
