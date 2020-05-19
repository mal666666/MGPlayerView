//
//  PlayerView.m
//  playerView
//
//  Created by Mac on 2020/5/8.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import "PlayerView.h"
#import "PlayerFullScreenViewController.h"
#import "PlayerFullScreenRotateAnimator.h"
#import <AVFoundation/AVFoundation.h>
#import "BrightnessView.h"


@interface PlayerView()

@property(strong, nonatomic) UIViewController *smallVC;
@property(strong, nonatomic) PlayerFullScreenViewController *fullVC;
@property(strong, nonatomic) PlayerFullScreenRotateAnimator *animator;

@end

@implementation PlayerView

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
-(void)playWithUrl:(NSString *)url{
    [self.contentView playWithUrl:url];
    [self.contentView.playerLayer.player addObserver:self.smallMaskView forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
    [self.contentView.playerLayer.player addObserver:self.fullMaskView forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
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

}
//设备方向完成改变
- (void)playerViewDeviceOrientationDidChange {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) &&!self.smallVC.presentedViewController) {
        [self toFullScreen:^{
        }];
    }else if ([UIDevice currentDevice].orientation ==UIInterfaceOrientationPortrait &&self.smallVC.presentedViewController ==self.fullVC){
        [self quitFullScreen:^{
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

@end
