//
//  RecordVC.h
//  Dominik
//
//  Created by amit varma on 03/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RecordingsVC.h"


@interface RecordVC : UIViewController<UIAlertViewDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
   
    IBOutlet UIButton *btnStartRecording;
    IBOutlet UITableView *tblRecord;
    IBOutlet UILabel *lblDate;
    
}

@property(nonatomic,strong) AVAudioRecorder *recorder;
@property(nonatomic,strong) NSMutableDictionary *recorderSettings;
@property(nonatomic,strong) NSString *recorderFilePath;
@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
@property(nonatomic,strong) NSString *audioFileName;

- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;

- (IBAction)startPlaying:(id)sender;
- (IBAction)stopPlaying:(id)sender;


- (IBAction)nextDate:(id)sender;
- (IBAction)previousDate:(id)sender;




- (IBAction)logoutAction:(id)sender;

- (IBAction)backbtnAction:(id)sender;
- (IBAction)recordDeleteAction:(id)sender;


@end
