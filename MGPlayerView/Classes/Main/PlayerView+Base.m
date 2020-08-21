//
//  PlayerView+Base.m
//  playerView
//
//  Created by MAL on 2020/5/11.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import "PlayerView+Base.h"
#import "PlayerGestureView.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerView+Property.h"

@interface PlayerView ()<CNPlayerGestureViewDelegate>

@end

@implementation PlayerView (Base)

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


@end
