//
//  FullMaskView.h
//  playerView
//
//  Created by MAL on 2020/5/11.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerViewProtocol.h"
#import "PlayerGestureView.h"
#import "CNPSlider.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FullMaskViewDelegate <NSObject>

@optional
-(void)fullMaskViewSliderValueChangeEvent:(UISlider *)slider;
-(void)fullMaskViewSliderTouchUpInsideEvent:(UISlider *)slider;
-(void)fullMaskViewSliderTapEvent:(UISlider*)slider;

@end


@interface FullMaskView : UIView<PlayerViewProtocol>

@property (nonatomic, strong) UIButton *lockBtn;
//手势层
@property(strong, nonatomic) PlayerGestureView *gestureView;
//进度条
@property (nonatomic, strong) CNPSlider *slider;
@property (nonatomic, strong) UIProgressView *progressView;
//当前时间
@property (nonatomic, strong) UILabel *currentTimeLab;
//总时间
@property (nonatomic, strong) UILabel *sumTimeLab;
//快进状态
@property (nonatomic, assign) BOOL  seekState;
//delegate
@property (nonatomic,   weak) id <FullMaskViewDelegate>delegate;
//菊花状态
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

-(void)hiddenMaskView;
-(void)showMaskView;
//显示隐藏锁屏按钮
-(void)showLockBtn;
-(void)hiddenLockBtn;

@end

NS_ASSUME_NONNULL_END
