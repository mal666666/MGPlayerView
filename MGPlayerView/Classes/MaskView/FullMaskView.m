//
//  FullMaskView.m
//  playerView
//
//  Created by MAL on 2020/5/11.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import "FullMaskView.h"
#import "PlayerView_prv.h"
#import "NSTimer+timerBlock.h"
#import "PlayerGestureView.h"
#import <AVFoundation/AVFoundation.h>

@interface FullMaskView ()<CNPlayerGestureViewDelegate>

//YES显示，NO消失
@property (nonatomic, assign) BOOL  maskViewSate;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *topToolView;
@property (nonatomic, strong) UIView *bottomToolView;
//倒计时
@property (nonatomic, strong) NSTimer *countdown;
@property (nonatomic, strong) UIButton *playBtn;
//锁屏按钮倒计时
@property (nonatomic, strong) NSTimer *lockBtnCountdown;



@end

@implementation FullMaskView

@synthesize delegateUI;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.gestureView.backgroundColor =[UIColor clearColor];
        [self.gestureView addGestureViewDelegate:self];
        self.topToolView.backgroundColor =[UIColor clearColor];
        self.bottomToolView.backgroundColor =[UIColor clearColor];
        self.backBtn.backgroundColor =[UIColor clearColor];
        self.playBtn.backgroundColor =[UIColor clearColor];
        self.lockBtn.backgroundColor =[UIColor clearColor];
        self.maskViewSate =YES;
        self.lockBtn.hidden =YES;
        [self hiddenMaskView];
        self.hidden =YES;
    }
    return self;
}

-(void)hiddenMaskView{
    if (self.maskViewSate) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.topToolView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.offset(-100);
            }];
            [self.bottomToolView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(100);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.maskViewSate =NO;
        }];
    }
}

-(void)showMaskView{
    if (!self.maskViewSate) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.topToolView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.offset(0);
            }];
            [self.bottomToolView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.offset(0);
            }];
            [self layoutIfNeeded];
            self.maskViewSate =YES;
        } completion:^(BOOL finished) {

        }];
    }
    [self.countdown invalidate];
    self.countdown =nil;
    self.countdown =  [NSTimer scheduledTimerWithTimeIntervalNotEmpty:MaskViewHiddenWaitingTime target:self selector:@selector(hiddenMaskView) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.countdown forMode:NSRunLoopCommonModes];
}

-(void)showLockBtn{
    self.lockBtn.hidden =NO;
    [_lockBtnCountdown invalidate];
    _lockBtnCountdown =nil;
    _lockBtnCountdown =  [NSTimer scheduledTimerWithTimeInterval:MaskViewHiddenWaitingTime block:^{
        self.lockBtn.hidden =YES;
    } repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_lockBtnCountdown forMode:NSRunLoopCommonModes];
}

-(void)hiddenLockBtn{
    self.lockBtn.hidden =YES;
}

-(void)playerGestureOneTapEvent{
    if (self.maskViewSate) {
        [self hiddenMaskView];
        self.lockBtn.hidden =YES;
    }else{
        [self showMaskView];
        [self showLockBtn];
    }
}

-(void)touchPlayAndPauseButtonEvent{
    if (self.delegateUI &&[self.delegateUI respondsToSelector:@selector(playBtnClickEvent:)]) {
        [self.delegateUI playBtnClickEvent:self];;
    }
}

-(void)touchLeftBackButtonEvent{
    if (self.delegateUI &&[self.delegateUI respondsToSelector:@selector(fullMaskViewBackEvent:completion:)]) {
        [self.delegateUI fullMaskViewBackEvent:self completion:^{}];
    }
}

-(void)touchLockButtonEvent:(UIButton *)btn{
    btn.selected =!btn.selected;
    if (self.delegateUI &&[self.delegateUI respondsToSelector:@selector(lockBtnClickEventWithState:)]) {
        [self.delegateUI lockBtnClickEventWithState:btn.selected];
    }
}

//监听 timeControlStatus 播放状态，播放中允许旋转屏幕
-(void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{

    if ([keyPath isEqualToString:@"timeControlStatus"]) {
        if (@available(iOS 10.0, *)) {
            AVPlayerTimeControlStatus status = [[change objectForKey:NSKeyValueChangeNewKey]integerValue];
            if (status == AVPlayerTimeControlStatusPlaying) {
                self.playBtn.selected =NO;
            }else{
                self.playBtn.selected =YES;
            }
        } else {
            // ios10.0之后才能够监听到暂停后继续播放的状态，ios10.0之前监测不到这个状态
            //但是可以监听到开始播放的状态 AVPlayerStatus  status监听这个属性。
        }
    }
}
#pragma mark ---lazy---

- (PlayerGestureView *)gestureView {
    if (!_gestureView) {
        _gestureView = [[PlayerGestureView alloc] init];
        [self addSubview:_gestureView];
        [_gestureView addGestureRecognizer];
        [_gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }
    return _gestureView;
}

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = [UIImage imageNamed:PlayerView(@"ZFPlayer_top_shadow")];
        _topToolView.layer.contents = (id)image.CGImage;
        [self addSubview:_topToolView];
        [_topToolView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(100);
        }];
    }
    return _topToolView;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = [UIImage imageNamed:PlayerView(@"ZFPlayer_bottom_shadow")];
        _bottomToolView.layer.contents = (id)image.CGImage;
        [self addSubview:_bottomToolView];
        [_bottomToolView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
            make.height.offset(100);
        }];
    }
    return _bottomToolView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(touchLeftBackButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed:PlayerView(@"fanhui")] forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
        [self.topToolView addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(44);
            make.top.offset(4);
            make.leftMargin.offset(40);
        }];
    }
    return _backBtn;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn addTarget:self action:@selector(touchPlayAndPauseButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [_playBtn setImage:[UIImage imageNamed:PlayerView(@"bofang")] forState:UIControlStateSelected];
        [_playBtn setImage:[UIImage imageNamed:PlayerView(@"zanting")] forState:UIControlStateNormal];
        [self.bottomToolView addSubview:_playBtn];
        [_playBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(44);
            make.bottom.offset(-4);
            make.leftMargin.offset(40);
        }];
    }
    return _playBtn;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn addTarget:self action:@selector(touchLockButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_lockBtn setImage:[UIImage imageNamed:PlayerView(@"suoping")] forState:UIControlStateSelected];
        [_lockBtn setImage:[UIImage imageNamed:PlayerView(@"jiesuo")] forState:UIControlStateNormal];
        [self addSubview:_lockBtn];
        [_lockBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(44);
            make.centerY.offset(0);
            make.leftMargin.offset(40);
        }];
    }
    return _lockBtn;
}


@end
