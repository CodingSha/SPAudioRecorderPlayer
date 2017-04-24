//
//  ZKHZAudioBtn.m
//  YiMath
//
//  Created by 沙少盼 on 2017/4/12.
//  Copyright © 2017年 Lemon_Mr.H. All rights reserved.
//

#import "ZKHZAudioBtn.h"

@interface ZKHZAudioBtn ()
{
    NSUInteger animationCount;
}
@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UIImageView *voiceView;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)UIButton *reRecorderBtn;
@end
@implementation ZKHZAudioBtn
- (instancetype)init{
    if (self = [super init]) {
        [self setTitle:@"按住 说话 仅限30秒" forState:UIControlStateNormal];
        [self setTitleColor:RGB(138, 138, 138) forState:UIControlStateNormal];
        [self addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(btnUp:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(btnDragUp:) forControlEvents:UIControlEventTouchDragExit];
        [self addTarget:self action:@selector(btnUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.layer.borderColor = RGB(204, 204, 204).CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 3;
    }
    return self;
}
- (ZKHZAudioUtil *)audioUtil{
    if (!_audioUtil) {
        _audioUtil = [[ZKHZAudioUtil alloc]init];
        WS(weakSelf);
        __weak typeof(_audioUtil)weakAudio = _audioUtil;
        //状态监听
        _audioUtil.status = ^(STATUS status){
            switch (status) {
                case STARTREC:
                {
                    NSLog(@"start Recorder");
                }
                    break;
                case STOPREC:
                {
                    NSLog(@"stop  Recorder");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf deleteImage];
                        [weakSelf updateSelfTitle];
                    });
                }
                    break;
                case PLAYSTR:
                {
                    [weakSelf startPlayingAnimation];//成功播放之后再播放动画
                }
                    break;
                case PLAYCOM:
                {
                    NSLog(@"Play finish");
                    [weakSelf stopPlayingAnimation];
                }
                    break;
                default:
                    break;
            }
        };
        //时间监听
        _audioUtil.timecount = ^(NSUInteger time){
            if (time == 30) {
                [weakAudio stopRecorder];
            }
        };
        //开启分贝数监听，并开启录音动画
        _audioUtil.metes = ^(CGFloat metes){
            [weakSelf setImageWithMetes:metes];
        };
    }
    return _audioUtil;
}

//按下
- (void)btnDown:(UIButton *)sender{
    if (self.audioUtil.timeCount >= 1&&![self.audioUtil.audioRecorder isRecording]) {//播放录音
        [self.audioUtil playAudio];
    }else{//录音
        [self.audioUtil startRecorder];
        [self updateImage];
    }
    
    NSLog(@"按下");
}
//松手
- (void)btnUp:(UIButton *)sender{
    if ([self.audioUtil.audioRecorder isRecording]) {
        [self.audioUtil stopRecorder];
        [self deleteImage];
    }
    NSLog(@"内松手");
}
//上滑
- (void)btnDragUp:(UIButton *)sender{
    NSLog(@"滑出");
}
- (void)btnUpOutside:(UIButton *)sender{
    [self.audioUtil cancleRecorder];
    [self deleteImage];
    NSLog(@"外松手");
}

- (void)setImageWithMetes:(CGFloat)metes{
    double lowPassResults = pow(10, (0.05 * metes));
    NSLog(@"%lf--%lu",lowPassResults,(unsigned long)self.state);
    //最大50  0
    //图片 小-》大
    if (self.state == 0) {
        [self.voiceView setImage:[UIImage imageNamed:@"return.png"]];
        self.voiceView.frame = CGRectMake(20, 10, 80, 80);
        self.title.text = @"松开手指，取消发送";
        self.title.textColor = COLOR_RED;
    }else{
        self.voiceView.frame = CGRectMake(25, 10, 80, 80);
        self.title.text = @"手指上滑，取消发送";
        self.title.textColor = COLOR_WHITE;
        
        if (0<lowPassResults<=0.06) {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_1.png"]];
        }else if (0.06<lowPassResults<=0.13) {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_2.png"]];
        }else if (0.13<lowPassResults<=0.20) {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_3.png"]];
        }else if (0.20<lowPassResults<=0.27) {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_4.png"]];
        }else if (0.27<lowPassResults<=0.34) {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_5.png"]];
        }else if (0.34<lowPassResults<=0.41) {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_6.png"]];
        }else if (0.41<lowPassResults<=0.48) {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_7.png"]];
        }else if (0.48<lowPassResults<=0.55) {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_8.png"]];
        }else if (0.55<lowPassResults<=0.62) {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_8.png"]];
        }else if (0.62<lowPassResults<=0.69) {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_8.png"]];
        }else if (0.69<lowPassResults<=0.76) {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_8.png"]];
        }else if (0.76<lowPassResults<=0.83) {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_8.png"]];
        }else if (0.83<lowPassResults<=0.9) {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_8.png"]];
        }else {
            [self.voiceView setImage:[UIImage imageNamed:@"voice_8.png"]];
        }
    }
}
- (void) deleteImage{
    [self.bgview removeFromSuperview];
}
- (void) updateImage
{
    self.bgview = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 60, SCREEN_HEIGHT/2 - 60, 120, 120)];
    self.bgview.backgroundColor = RGBA(0, 0, 0, 0.4);
    self.bgview.layer.cornerRadius = 5;
    
    self.voiceView = [[UIImageView alloc]initWithFrame:CGRectMake(25,10,80,80)];
    [self.imageView setImage:[UIImage imageNamed:@"voice_1.png"]];
    [self.bgview addSubview:self.voiceView];
    
    
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 120, 20)];
    self.title.textAlignment = 1;
    self.title.font = [UIFont systemFontOfSize:10];
    self.title.text = @"手指上滑，取消发送";
    self.title.textColor = COLOR_WHITE;
    
    [self.bgview addSubview:self.title];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgview];
}
- (void)updateSelfTitle{
    if (self.audioUtil.timeCount >= 1) {
        if (self.complte) {
            self.complte();
        }
        self.backgroundColor = RGB(65, 200, 255);
        [self setTitle:[NSString stringWithFormat:@"%zd秒语音 点击收听",self.audioUtil.timeCount] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"bofanganniu3"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"bofanganniu3"] forState:UIControlStateHighlighted];
        [self setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        self.layer.borderColor = RGB(65, 200, 255).CGColor;
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, -8);
    }else{
        self.backgroundColor = COLOR_WHITE;
        [self setTitle:@"按住 说话 仅限30秒" forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self setTitleColor:RGB(138, 138, 138) forState:UIControlStateNormal];
        self.layer.borderColor = RGB(204, 204, 204).CGColor;
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
- (void)startPlayingAnimation{
    WS(weakSelf);
     animationCount = 1;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playAnimation) userInfo:nil repeats:YES];
}
- (void)playAnimation{
    [self setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bofanganniu%zd",animationCount]] forState:UIControlStateNormal];
    animationCount ++;
    if (animationCount == 4) {
        animationCount = 1;
    }
}
- (void)stopPlayingAnimation{
    [self.timer invalidate];
    [self setImage:[UIImage imageNamed:@"bofanganniu3"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"bofanganniu3"] forState:UIControlStateHighlighted];
}
//重录回到初始未录音状态
- (void)reRecorder{
    if ([self.audioUtil.audioPlayer isPlaying]) {
        [self.audioUtil.audioPlayer stop];
    }
    if ([self.audioUtil.audioRecorder isRecording]) {
        [self.audioUtil.audioRecorder stop];
    }
    self.audioUtil.timeCount = 0;
    self.audioUtil.url = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%.0f.wav",[[NSDate date] timeIntervalSince1970]]];
    self.audioUtil.audioRecorder = nil;
    self.audioUtil.audioPlayer = nil;
    [self.audioUtil.audioRecorder deleteRecording];
    [self updateSelfTitle];
    
}
- (void)dealloc{
    [self deleteImage];
    if (_audioUtil) {
        [_audioUtil stopPlayAudio];
        if ([_audioUtil.audioRecorder isRecording]) {
            [_audioUtil stopRecorder];
        }
    }
}
@end
