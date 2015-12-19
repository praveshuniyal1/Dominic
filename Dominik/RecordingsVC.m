//
//  RecordingsVC.m
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "RecordingsVC.h"
#import "AppDelegate.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface RecordingsVC ()
{
    NSMutableDictionary*  recordSetting ;
    NSMutableDictionary*  editedObject ;
    NSString* recorderFilePath;
    AVAudioRecorder* recorder ;
    AVAudioPlayer *audioPlayerl;
    NSString *userId;
    NSString *selectDate;
}

@end

@implementation RecordingsVC
@synthesize recordDic;
@synthesize recorder,recorderSettings,recorderFilePath;
@synthesize audioPlayer,audioFileName;


- (void)viewDidLoad
{
    [super viewDidLoad];
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startPlaying:(id)sender
{
    if (btnStartStop.isSelected==NO)
    {
        NSLog(@"playRecording");
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, [recordDic valueForKey:@"recordName"]]];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = 0;
        [audioPlayer play];
        NSLog(@"playing");
        btnStartStop.alpha=0.5;
        [btnStartStop setSelected:YES];
    }
    else if (btnStartStop.isSelected==YES)
    {
        btnStartStop.alpha=1;
        [btnStartStop setSelected:NO];
        [audioPlayer stop];
        NSLog(@"stopped");
    }
    
}


- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
