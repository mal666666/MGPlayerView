//
//  PlayerView+Property.h
//  MGPlayerView
//
//  Created by Mac on 2020/5/21.
//

#import "MGPlayerView.h"
#import "PlayerContentView.h"
#import "SmallMaskView.h"
#import "FullMaskView.h"
#import "FullMaskLockView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGPlayerView ()

//播放层
@property(strong, nonatomic) PlayerContentView *contentView;
//小屏浮层
@property(strong, nonatomic) SmallMaskView *smallMaskView;
//全屏浮层
@property(strong, nonatomic) FullMaskView *fullMaskView;
//锁屏层
@property(strong, nonatomic) FullMaskLockView *lockView;

@end

NS_ASSUME_NONNULL_END
