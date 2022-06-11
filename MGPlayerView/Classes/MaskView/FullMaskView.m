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

+ (NSBundle * _Nullable)MGPlayerViewBundle {
    return [NSBundle bundleWithURL:[[[NSBundle bundleForClass:NSClassFromString(@"MGPlayerView")] resourceURL] URLByAppendingPathComponent:@"MGPlayerView.bundle"]];
}

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
        
        [self.bottomToolView addSubview:self.currentTimeLab];
        [self.bottomToolView addSubview:self.sumTimeLab];
        [self.bottomToolView addSubview:self.progressView];
        [self.bottomToolView addSubview:self.slider];
        
        [self addSubview:self.loadingView];
        
        self.maskViewSate =YES;
        self.lockBtn.hidden =YES;
        [self hiddenMaskView];
        self.hidden =YES;
        [self updateUILayout];
    }
    return self;
}

-(void)updateUILayout {
    [self.currentTimeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(17);
        make.bottom.equalTo(self.progressView.mas_top).offset(-16);
        make.left.equalTo(self.bottomToolView.mas_leftMargin).offset(20);
    }];
    
    [self.sumTimeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(17);
        make.bottom.equalTo(self.progressView.mas_top).offset(-16);
        make.right.equalTo(self.bottomToolView.mas_rightMargin).offset(-20);
    }];
    
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomToolView.mas_leftMargin).offset(20);
        make.right.equalTo(self.bottomToolView.mas_rightMargin).offset(-20);
        make.bottom.equalTo(self.playBtn.mas_top).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    [self.slider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomToolView.mas_leftMargin).offset(20);
        make.right.equalTo(self.bottomToolView.mas_rightMargin).offset(-20);
        make.centerY.equalTo(self.progressView.mas_centerY); 
        make.height.mas_equalTo(30);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
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
    if (self.delegateUI &&[self.delegateUI respondsToSelector:@selector(playStateEvent:state:)]) {
        [self.delegateUI playStateEvent:self state:NO];
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

- (void)touchSliderValueChangeEvent:(UISlider *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(fullMaskViewSliderValueChangeEvent:)]) {
        [self.delegate fullMaskViewSliderValueChangeEvent:sender];
    }
}

- (void)touchSliderTouchDownEvent:(UISlider *)sender {
    [self.countdown setFireDate:[NSDate distantFuture]];
    self.seekState =YES;
}

- (void)touchSliderTouchUpInsideEvent:(UISlider *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(fullMaskViewSliderTouchUpInsideEvent:)]) {
        [self.delegate fullMaskViewSliderTouchUpInsideEvent:self.slider];
    }
    [self.countdown setFireDate:[NSDate dateWithTimeIntervalSinceNow:MaskViewHiddenWaitingTime]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC) , dispatch_get_main_queue(), ^{
        self.seekState =NO;
    });
}

- (void)touchSliderTouchDragExitEvent:(UISlider *)sender {
    self.seekState =NO;
}

- (void)touchSliderTouchCancelEvent:(UISlider *)sender {
    self.seekState =NO;
}

- (void)touchTapSliderEvent:(UITapGestureRecognizer *)recognizer {
    if ([recognizer.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)recognizer.view;
        CGPoint point    = [recognizer locationInView:slider];
        CGFloat length   = slider.frame.size.width;
        CGFloat tapValue = point.x / length;
        self.slider.value =tapValue;
        if (self.delegate &&[self.delegate respondsToSelector:@selector(fullMaskViewSliderTapEvent:)]) {
            [self.delegate fullMaskViewSliderTapEvent:self.slider];
        }
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
                [self.loadingView stopAnimating];
            }else if (status == AVPlayerTimeControlStatusPaused){
                self.playBtn.selected =YES;
            }else{
                self.playBtn.selected =YES;
                [self.loadingView startAnimating];
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
//        UIImage *image = [UIImage imageNamed:PlayerView(@"ZFPlayer_top_shadow")];
        UIImage *image = [UIImage imageNamed:@"ZFPlayer_top_shadow" inBundle:[FullMaskView MGPlayerViewBundle] compatibleWithTraitCollection:nil];
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
//        UIImage *image = [UIImage imageNamed:PlayerView(@"ZFPlayer_bottom_shadow")];
        UIImage *image = [UIImage imageNamed:@"ZFPlayer_bottom_shadow" inBundle:[FullMaskView MGPlayerViewBundle] compatibleWithTraitCollection:nil];
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
//        [_backBtn setImage:[UIImage imageNamed:PlayerView(@"fanhui")] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"fanhui" inBundle:[FullMaskView MGPlayerViewBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
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
//        [_playBtn setImage:[UIImage imageNamed:PlayerView(@"bofang")] forState:UIControlStateSelected];
//        [_playBtn setImage:[UIImage imageNamed:PlayerView(@"zanting")] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"bofang" inBundle:[FullMaskView MGPlayerViewBundle] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        [_playBtn setImage:[UIImage imageNamed:@"zanting" inBundle:[FullMaskView MGPlayerViewBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        _playBtn.selected =YES;
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
//        [_lockBtn setImage:[UIImage imageNamed:PlayerView(@"suoping")] forState:UIControlStateSelected];
//        [_lockBtn setImage:[UIImage imageNamed:PlayerView(@"jiesuo")] forState:UIControlStateNormal];
        [_lockBtn setImage:[UIImage imageNamed:@"suoping" inBundle:[FullMaskView MGPlayerViewBundle] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        [_lockBtn setImage:[UIImage imageNamed:@"jiesuo" inBundle:[FullMaskView MGPlayerViewBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [self addSubview:_lockBtn];
        [_lockBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(44);
            make.centerY.offset(0);
            make.leftMargin.offset(40);
        }];
    }
    return _lockBtn;
}

- (UILabel *)currentTimeLab {
    if (!_currentTimeLab) {
        _currentTimeLab = [[UILabel alloc] init];
        _currentTimeLab.textColor = [UIColor whiteColor];
        _currentTimeLab.font = [UIFont systemFontOfSize:10];
        _currentTimeLab.textAlignment = NSTextAlignmentCenter;
        _currentTimeLab.text = @"00:00";
        _currentTimeLab.hidden = YES;
    }
    return _currentTimeLab;
}

- (UILabel *)sumTimeLab {
    if (!_sumTimeLab) {
        _sumTimeLab = [[UILabel alloc] init];
        _sumTimeLab.font = [UIFont systemFontOfSize:10];
        _sumTimeLab.textColor = [UIColor whiteColor];
        _sumTimeLab.textAlignment = NSTextAlignmentCenter;
        _sumTimeLab.text = @"00:00";
        _sumTimeLab.hidden = YES;
    }
    return _sumTimeLab;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor whiteColor];
        _progressView.progressTintColor = [UIColor redColor];
        _progressView.progress = 0.0;
        _progressView.progressViewStyle = UIProgressViewStyleBar;
        _progressView.backgroundColor =[UIColor grayColor];
        _progressView.hidden = YES;
    }
    return _progressView;
}

- (CNPSlider *)slider {
    if (!_slider) {
        _slider = [[CNPSlider alloc] init];
        //_slider.sliderHeight = 2;
        _slider.maximumTrackTintColor = [UIColor clearColor];
        [_slider setThumbImage:[UIImage imageNamed:@"thumbImage" inBundle:[FullMaskView MGPlayerViewBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"thumbImage_h" inBundle:[FullMaskView MGPlayerViewBundle] compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
//        [_slider setThumbImage:[UIImage imageNamed:PlayerView(@"thumbImage")] forState:UIControlStateNormal];
//        [_slider setThumbImage:[UIImage imageNamed:PlayerView(@"thumbImage_h")] forState:UIControlStateHighlighted];
        [_slider addTarget:self action:@selector(touchSliderValueChangeEvent:) forControlEvents:(UIControlEventValueChanged)];
        [_slider addTarget:self action:@selector(touchSliderTouchDownEvent:) forControlEvents:(UIControlEventTouchDown)];
        [_slider addTarget:self action:@selector(touchSliderTouchUpInsideEvent:) forControlEvents:(UIControlEventTouchUpInside)];
        [_slider addTarget:self action:@selector(touchSliderTouchDragExitEvent:) forControlEvents:(UIControlEventTouchDragExit)];
        [_slider addTarget:self action:@selector(touchSliderTouchCancelEvent:) forControlEvents:(UIControlEventTouchCancel)];
        //点击slider
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTapSliderEvent:)];
        [_slider addGestureRecognizer:sliderTap];
        _slider.hidden = YES;
    }
    return _slider;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _loadingView.hidden = YES;
    }
    return _loadingView;
}

@end
