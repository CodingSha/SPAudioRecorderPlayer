//
//  ZKHZAudioRecorderUtil.m
//  AudioTest
//
//  Created by 沙少盼 on 2017/4/10.
//  Copyright © 2017年 沙少盼. All rights reserved.
//

#import "ZKHZAudioUtil.h"
@interface ZKHZAudioUtil ()<AVAudioPlayerDelegate>
{
    NSTimer *_meterTimer;
    NSTimer *_timer;
}
@end
@implementation ZKHZAudioUtil

#pragma mark - lazeLoading
- (NSString *)url{
    if (!_url) {
        _url = NSTemporaryDirectory();
        _url = [_url stringByAppendingString:[NSString stringWithFormat:@"%.0f.wav",[[NSDate date] timeIntervalSince1970]]];
    }
    return _url;
}
- (NSDictionary *)recorderSettings{
    if (!_recorderSettings) {
        _recorderSettings = @{
                              AVSampleRateKey:[NSNumber numberWithFloat:8000],
                              AVFormatIDKey:[NSNumber numberWithInt: kAudioFormatLinearPCM],
                              AVLinearPCMBitDepthKey:[NSNumber numberWithInt:16],
                              AVNumberOfChannelsKey:[NSNumber numberWithInt:1],
                              };
    }
    return _recorderSettings;
}
- (AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        NSError *initError;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.url] settings:self.recorderSettings error:&initError];
        _audioRecorder.meteringEnabled = YES;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    }
    return _audioRecorder;
}
- (AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSError *initError;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.url] error:&initError];
        _audioPlayer.delegate = self;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    return _audioPlayer;
}
#pragma mark - IMP
- (void)startRecorder{
    BOOL success = [self.audioRecorder record];
    if (success) {
        NSLog(@"开启录音成功");
        if (self.status) {
            self.status(STARTREC);
        }
        self.timeCount = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
        if (self.metes) {
            [self getMetes];
        }
    }else{
        NSLog(@"开启录音失败");
    }
}

- (void)stopRecorder{
    [self.audioRecorder stop];
    NSLog(@"录音结束");
    if (self.status) {
        self.status(STOPREC);
    }
    [_meterTimer invalidate];
    [_timer invalidate];
}
- (void)cancleRecorder{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder deleteRecording];
        NSLog(@"取消录音");
        if (self.status) {
            self.status(CANCLEREC);
        }
        [self stopRecorder];
        self.timeCount = 0;
    }
}
- (void)playAudio{
    if ([self.audioPlayer isPlaying]) {
        return;
    }
    BOOL success = [self.audioPlayer play];
    if (success) {
        if (self.status) {
            self.status(PLAYSTR);
        }
        NSLog(@"播放成功");
    }else{
        NSLog(@"播放失败");
    }
}
- (void)stopPlayAudio{
    [self.audioPlayer stop];
    
}
#pragma mark - private Method
- (void)getMetes{
    _meterTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(setVoiceImage) userInfo:nil repeats:YES];
}
-(void)setVoiceImage{
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder updateMeters];
        float peakPower = [self.audioRecorder peakPowerForChannel:0];
        if (self.metes) {
            self.metes(peakPower);
        }
    }
}
- (void)countTime{
    self.timeCount ++;
    self.timecount(self.timeCount);
}
#pragma mark - audioPlayerDidFinishPlaying
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (self.status) {
        self.status(PLAYCOM);
    }
}
@end
