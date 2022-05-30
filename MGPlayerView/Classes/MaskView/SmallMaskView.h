//
//  SmallMaskView.h
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

@protocol SmallMaskViewDelegate <NSObject>

@optional
-(void)smallMaskViewSliderValueChangeEvent:(UISlider *)slider;
-(void)smallMaskViewSliderTouchUpInsideEvent:(UISlider *)slider;
-(void)smallMaskViewSliderTapEvent:(UISlider*)slider;

@end

@interface SmallMaskView : UIView<PlayerViewProtocol>

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
// delegate
@property (nonatomic,   weak) id <SmallMaskViewDelegate>delegate;

-(void)hiddenMaskView;
-(void)showMaskView;

@end

NS_ASSUME_NONNULL_END
