//
//  MGPlayerView.m
//  MGplayerView
//
//  Created by Mac on 2020/5/8.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import "MGPlayerView.h"
#import "PlayerFullScreenViewController.h"
#import "PlayerFullScreenRotateAnimator.h"
#import <AVFoundation/AVFoundation.h>
#import "BrightnessView.h"
#import "MGPlayerView+Property.h"
#import "NSString+customTime.h"


@interface MGPlayerView()

@property(strong, nonatomic) UIViewController *smallVC;
@property(strong, nonatomic) PlayerFullScreenViewController *fullVC;
@property(strong, nonatomic) PlayerFullScreenRotateAnimator *animator;
@property(strong, nonatomic) id obs;

@end

@implementation MGPlayerView

@synthesize delegateUI;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor blackColor];
        //物理旋转
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerViewDeviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        //播放层
        self.contentView.backgroundColor =[UIColor blackColor];
        //小浮层
        self.smallMaskView.backgroundColor =[UIColor clearColor];
        [self.smallMaskView.gestureView addGestureViewDelegate:self];
        //大浮层
        self.fullMaskView.backgroundColor =[UIColor clearColor];
        [self.fullMaskView.gestureView addGestureViewDelegate:self];
        //锁屏层
        self.lockView.backgroundColor =[UIColor clearColor];
        __weak typeof(self) weakSelf =self;
        self.lockView.lockViewTapBlock = ^{
            if (weakSelf.fullMaskView.lockBtn.hidden) {
                [weakSelf.fullMaskView showLockBtn];
            }else{
                [weakSelf.fullMaskView hiddenLockBtn];
            }
        };
        //调节亮度的动画
        [self addSubview:[BrightnessView sharedBrightnessView]];
    }
    return self;
}
//处理锁屏按钮事件
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect rect =[self convertRect:self.fullMaskView.lockBtn.frame toView:self];
    if (CGRectContainsPoint(rect, point) &&!self.fullMaskView.hidden &&!self.fullMaskView.lockBtn.hidden) {
        return self.fullMaskView.lockBtn;
    }else{
        return [super hitTest:point withEvent:event];
    }
}
//设置播放view层
-(void)setPlayUrl:(NSString *)url{
    if (self.obs) {
        [self.contentView.playerLayer.player removeTimeObserver:self.obs];
        self.obs = nil;
    }
    [self.contentView setPlayUrl:url];
    [self playerCallback];
}
-(void)setUrl:(NSURL *)url{
    if (self.obs) {
        [self.contentView.playerLayer.player removeTimeObserver:self.obs];
        self.obs = nil;
    }
    [self.contentView setUrl:url];
    [self playerCallback];
}
//播放回调
-(void)playerCallback {
    [self.contentView.playerLayer.player addObserver:self.smallMaskView forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
    [self.contentView.playerLayer.player addObserver:self.fullMaskView forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
    __weak typeof(self) weakSelf =self;
    self.obs = [self.contentView.playerLayer.player addPeriodicTimeObserverForInterval: CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        Float64 cur = CMTimeGetSeconds(time);
        Float64 dur = CMTimeGetSeconds(weakSelf.contentView.playerLayer.player.currentItem.duration);
        //NSLog(@"%f-----%f",cur,dur);
        if (isnan(dur)) {
            //smallMaskView
            weakSelf.smallMaskView.currentTimeLab.hidden = YES;
            weakSelf.smallMaskView.sumTimeLab.hidden = YES;
            weakSelf.smallMaskView.slider.hidden = YES;
            weakSelf.smallMaskView.progressView.hidden = YES;
            //fullMaskView
            weakSelf.fullMaskView.currentTimeLab.hidden = YES;
            weakSelf.fullMaskView.sumTimeLab.hidden = YES;
            weakSelf.fullMaskView.slider.hidden = YES;
            weakSelf.fullMaskView.progressView.hidden = YES;
        }else{
            if (!weakSelf.smallMaskView.seekState && !weakSelf.fullMaskView.seekState) {
                //smallMaskView
                weakSelf.smallMaskView.currentTimeLab.hidden = NO;
                weakSelf.smallMaskView.sumTimeLab.hidden = NO;
                weakSelf.smallMaskView.slider.hidden = NO;
                weakSelf.smallMaskView.progressView.hidden = NO;
                //weakSelf.smallMaskView.progressView.progress =player.bufferDuration/player.duration;
                weakSelf.smallMaskView.currentTimeLab.text =[NSString customTimeWithSecond:cur];
                weakSelf.smallMaskView.sumTimeLab.text =[NSString customTimeWithSecond:dur];
                weakSelf.smallMaskView.slider.value = cur/dur;
                //fullMaskView
                weakSelf.fullMaskView.currentTimeLab.hidden = NO;
                weakSelf.fullMaskView.sumTimeLab.hidden = NO;
                weakSelf.fullMaskView.slider.hidden = NO;
                weakSelf.fullMaskView.progressView.hidden = NO;
                //weakSelf.smallMaskView.progressView.progress =player.bufferDuration/player.duration;
                weakSelf.fullMaskView.currentTimeLab.text =[NSString customTimeWithSecond:cur];
                weakSelf.fullMaskView.sumTimeLab.text =[NSString customTimeWithSecond:dur];
                weakSelf.fullMaskView.slider.value = cur/dur;
            }
        }
    }];
}
//播放
-(void)play{
    [self.contentView.playerLayer.player play];
}
//支持全屏
-(void)supportFullScreenWithVC:(UIViewController *)vc{
    self.smallVC =vc;
}
//退出全屏
-(void)quitFullScreen:(void (^)(void))completion{
    if (!self.lockView.hidden) {
        return;//锁屏不退出
    }
    if (self.fullVC && self.fullVC.presentingViewController) {
        self.smallMaskView.hidden =YES;
        self.fullMaskView.hidden =YES;
        [self.fullVC dismissViewControllerAnimated:YES completion:^{
            self.smallMaskView.hidden =NO;
            if (completion) {
                completion();
            }
        }];
    }
}
//进入全屏
-(void)toFullScreen:(void (^)(void))completion{
    if (self.smallVC && self.fullVC) {
        self.smallMaskView.hidden =YES;
        self.fullMaskView.hidden =YES;
        [self.smallVC presentViewController:self.fullVC animated:YES completion:^{
            self.fullMaskView.hidden =NO;
            if (completion) {
                completion();
            }
        }];
    }
}
//退出小屏
-(void)quitSmallScreen{
    self.contentView.playerLayer.player = nil;
}
//设备方向完成改变
- (void)playerViewDeviceOrientationDidChange {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) &&!self.smallVC.presentedViewController) {
//        [self toFullScreen:^{
//        }];
        [self smallMaskViewToFullScreenEvent:self completion:^{
            
        }];
    }else if ([UIDevice currentDevice].orientation ==UIInterfaceOrientationPortrait &&self.smallVC.presentedViewController ==self.fullVC){
//        [self quitFullScreen:^{
//        }];
        [self fullMaskViewBackEvent:self completion:^{
            
        }];
    }else{
    }
}
#pragma mark ---lazy---
//全屏vc
-(PlayerFullScreenViewController *)fullVC{
    if (!_fullVC) {
        _fullVC =[[PlayerFullScreenViewController alloc]init];
        _fullVC.modalPresentationStyle =UIModalPresentationFullScreen;
        _fullVC.transitioningDelegate =self.animator;
    }
    return _fullVC;
}
//旋转动画
-(PlayerFullScreenRotateAnimator *)animator{
    if (!_animator) {
        _animator =[[PlayerFullScreenRotateAnimator alloc]init];
        _animator.playerView =self;
    }
    return _animator;
}
//播放层
-(PlayerContentView *)contentView{
    if (!_contentView) {
        _contentView =[[PlayerContentView alloc]init];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }
    return _contentView;
}
//小浮层
-(SmallMaskView *)smallMaskView{
    if (!_smallMaskView) {
        _smallMaskView =[[SmallMaskView alloc]init];
        [self addSubview:_smallMaskView];
        _smallMaskView.clipsToBounds =YES;
        _smallMaskView.delegateUI =self;
        _smallMaskView.delegate = (id)self;
        [_smallMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_smallMaskView.superview).insets(UIEdgeInsetsZero);
        }];
    }
    return _smallMaskView;
}
//大浮层
-(FullMaskView *)fullMaskView{
    if (!_fullMaskView) {
        _fullMaskView =[[FullMaskView alloc]init];
        [self addSubview:_fullMaskView];
        _fullMaskView.clipsToBounds =YES;
        _fullMaskView.delegateUI =self;
        _fullMaskView.delegate = (id)self;
        [_fullMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_fullMaskView.superview).insets(UIEdgeInsetsZero);
        }];
    }
    return _fullMaskView;
}
//锁屏层
-(FullMaskLockView *)lockView{
    if (!_lockView) {
        _lockView =[[FullMaskLockView alloc]init];
        [self addSubview:_lockView];
        _lockView.hidden =YES;
        [_lockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_fullMaskView.superview).insets(UIEdgeInsetsZero);
        }];
    }
    return _lockView;
}

-(void)dealloc{
    NSLog(@"PlayerView dealloc");
}

@end
