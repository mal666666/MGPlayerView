//
//  MGPlayerView+Base.m
//  MGplayerView
//
//  Created by MAL on 2020/5/11.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import "MGPlayerView+Base.h"
#import "PlayerGestureView.h"
#import <AVFoundation/AVFoundation.h>
#import "MGPlayerView+Property.h"
#import "NSString+customTime.h"

@interface MGPlayerView ()<CNPlayerGestureViewDelegate,SmallMaskViewDelegate,FullMaskViewDelegate>

@end

@implementation MGPlayerView (Base)

#pragma mark ---CNPlayerGestureViewDelegate---
-(void)playerGesturePinchEventType:(PlayerGesturePinchType)type{
    switch (type) {
        case PlayerGesturePinchType_AspectFill:
            self.contentView.playerLayer.videoGravity =AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            self.contentView.playerLayer.videoGravity =AVLayerVideoGravityResizeAspect;
            break;
    }
}

-(void)playerGestureDoubleTapEvent{
    //双击手势和播放暂停按钮事件一样
    [self playStateEvent:self state:NO];
}

#pragma mark ---PlayerViewUICallbackProtocol---
-(void)smallMaskViewBackEvent:(id)playerView{
    if (self.delegateUI &&[self.delegateUI respondsToSelector:@selector(smallMaskViewBackEvent:)]) {
        [self.delegateUI smallMaskViewBackEvent:playerView];
    }
}

-(void)playStateEvent:(id)view state:(BOOL)isPlaying{
    BOOL state = NO;
    if (@available(iOS 10.0, *)) {
        if (self.contentView.playerLayer.player.timeControlStatus ==AVPlayerTimeControlStatusPlaying){
            [self.contentView.playerLayer.player pause];
            state = NO;
        }else{
            Float64 cur = CMTimeGetSeconds(self.contentView.playerLayer.player.currentItem.currentTime);
            Float64 dur = CMTimeGetSeconds(self.contentView.playerLayer.player.currentItem.duration);
            //NSLog(@"%f====%f",cur,dur);
            if (cur == dur) {// 如果播放结束重播
                [self.contentView.playerLayer.player seekToTime:kCMTimeZero];
            }
            
            [self.contentView.playerLayer.player play];
            state = YES;
        }
    } else {
        // Fallback on earlier versions
    }
    if (self.delegateUI &&[self.delegateUI respondsToSelector:@selector(playStateEvent:state:)]) {
        [self.delegateUI playStateEvent:view state:state];
    }
}

-(void)smallMaskViewToFullScreenEvent:(id)playerView completion:(void (^)(void))completion{
    if (self.delegateUI &&[self.delegateUI respondsToSelector:@selector(smallMaskViewToFullScreenEvent:completion:)]) {
        [self.delegateUI smallMaskViewToFullScreenEvent:playerView completion:completion];
    }

    [self toFullScreen:completion];
}

-(void)fullMaskViewBackEvent:(id)playerView completion:(void (^)(void))completion{
    if (self.delegateUI &&[self.delegateUI respondsToSelector:@selector(fullMaskViewBackEvent:completion:)]) {
        [self.delegateUI fullMaskViewBackEvent:playerView completion:completion];
    }

    [self quitFullScreen:completion];
}

-(void)lockBtnClickEventWithState:(BOOL)state{
    self.lockView.hidden =!state;
    if (state) {
        [self.fullMaskView hiddenMaskView];
    }else{
        [self.fullMaskView showMaskView];
        [self.fullMaskView showLockBtn];
    }
}

#pragma mark  ---smallMaskViewDelegate---

-(void)smallMaskViewSliderValueChangeEvent:(UISlider *)slider{
    Float64 dur = CMTimeGetSeconds(self.contentView.playerLayer.player.currentItem.duration);
    self.smallMaskView.currentTimeLab.text = [NSString customTimeWithSecond:dur*slider.value];
}

-(void)smallMaskViewSliderTouchUpInsideEvent:(UISlider *)slider{
    Float64 dur = CMTimeGetSeconds(self.contentView.playerLayer.player.currentItem.duration);
    [self.contentView.playerLayer.player seekToTime:CMTimeMake(dur*slider.value, 1)];
}

-(void)smallMaskViewSliderTapEvent:(UISlider *)slider{
    Float64 dur = CMTimeGetSeconds(self.contentView.playerLayer.player.currentItem.duration);
    [self.contentView.playerLayer.player seekToTime:CMTimeMake(dur*slider.value, 1)];
}

#pragma mark  ---fullMaskViewDelegate---

-(void)fullMaskViewSliderValueChangeEvent:(UISlider *)slider{
    Float64 dur = CMTimeGetSeconds(self.contentView.playerLayer.player.currentItem.duration);
    self.fullMaskView.currentTimeLab.text = [NSString customTimeWithSecond:dur*slider.value];
}

-(void)fullMaskViewSliderTouchUpInsideEvent:(UISlider *)slider{
    Float64 dur = CMTimeGetSeconds(self.contentView.playerLayer.player.currentItem.duration);
    [self.contentView.playerLayer.player seekToTime:CMTimeMake(dur*slider.value, 1)];
}

-(void)fullMaskViewSliderTapEvent:(UISlider *)slider{
    Float64 dur = CMTimeGetSeconds(self.contentView.playerLayer.player.currentItem.duration);
    [self.contentView.playerLayer.player seekToTime:CMTimeMake(dur*slider.value, 1)];
}

@end
