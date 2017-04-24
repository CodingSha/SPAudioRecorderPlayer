//
//  ZKHZAudioBtn.h
//  YiMath
//
//  Created by 沙少盼 on 2017/4/12.
//  Copyright © 2017年 Lemon_Mr.H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKHZAudioUtil.h"
@class ZKHZAudioFileModel;
@interface ZKHZAudioBtn : UIButton
@property (nonatomic,strong)ZKHZAudioUtil *audioUtil;
//完成录音的回调
@property (nonatomic,copy)void(^complte)();
//重置按钮样式
- (void)updateSelfTitle;
//重录
- (void)reRecorder;
@end
