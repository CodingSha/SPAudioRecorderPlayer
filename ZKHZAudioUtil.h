//
//  ZKHZAudioRecorderUtil.h
//  AudioTest
//
//  Created by 沙少盼 on 2017/4/10.
//  Copyright © 2017年 沙少盼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM (NSUInteger ,STATUS){
    //开始录音
    STARTREC = 1,
    //结束录音
    STOPREC     ,
    //取消录音
    CANCLEREC   ,
    //开始播放
    PLAYSTR     ,
    //结束播放
    PLAYCOM
};
@interface ZKHZAudioUtil : NSObject
//录音存放地址
@property (nonatomic,copy)NSString *url;
//录音配置
@property (nonatomic,copy)NSDictionary *recorderSettings;
//录音录制实例
@property (nonatomic,strong)AVAudioRecorder *audioRecorder;
//录音播放实例
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;
//录音时间
@property (nonatomic,assign)NSUInteger timeCount;
//监听录音时间
@property (nonatomic,copy)void(^timecount)(NSUInteger time);
//录音分贝数
@property (nonatomic,copy)void(^metes)(CGFloat metes);
//监听录音和播放的状态
@property (nonatomic,copy)void(^status)(STATUS status);
#pragma mark - method
//开始录音
- (void)startRecorder;
//结束录音
- (void)stopRecorder;
//取消录音
- (void)cancleRecorder;
//播放
- (void)playAudio;
//停止播放
- (void)stopPlayAudio;
@end
