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
    if (self.contentView.playerLayer.player.timeControlStatus ==AVPlayerTimeControlStatusPlaying){
        [self.contentView.playerLayer.player pause];
    }else{
        [self.contentView.playerLayer.player play];
    }
}

#pragma mark ---PlayerViewUICallbackProtocol---
-(void)smallMaskViewBackEvent:(id)playerView{
    if (self.delegateUI &&[self.delegateUI respondsToSelector:@selector(smallMaskViewBackEvent:)]) {
        [self.delegateUI smallMaskViewBackEvent:playerView];
    }
}

-(void)playBtnClickEvent:(id)view{
    [self playerGestureDoubleTapEvent];
}

-(void)smallMaskViewToFullScreenEvent:(id)playerView completion:(void (^)(void))completion{
    [self toFullScreen:completion];
}

-(void)fullMaskViewBackEvent:(id)playerView completion:(void (^)(void))completion{
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
