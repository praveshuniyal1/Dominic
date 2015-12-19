//
//  RecordingsVC.h
//  Dominik
//
//  Created by amit varma on 04/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordingsVC : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    
    IBOutlet UIButton *btnStartStop;
    
    
}


@property(nonatomic,strong) AVAudioRecorder *recorder;
@property(nonatomic,strong) NSMutableDictionary *recorderSettings;
@property(nonatomic,strong) NSString *recorderFilePath;
@property(nonatomic,strong) AVAudioPlayer *audioPlayer;
@property(nonatomic,strong) NSString *audioFileName;


- (IBAction)startPlaying:(id)sender;
- (IBAction)backBtnAction:(id)sender;

@property(strong,nonatomic)NSMutableDictionary *recordDic;
@end
