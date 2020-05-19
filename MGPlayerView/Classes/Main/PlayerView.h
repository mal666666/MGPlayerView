//
//  PlayerView.h
//  playerView
//
//  Created by Mac on 2020/5/8.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerContentView.h"
#import "SmallMaskView.h"
#import "FullMaskView.h"
#import "FullMaskLockView.h"
#import "PlayerViewCallbackProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayerView : UIView<PlayerViewProtocol,PlayerViewUICallbackProtocol>

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
