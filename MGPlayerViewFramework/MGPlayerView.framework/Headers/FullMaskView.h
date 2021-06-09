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

NS_ASSUME_NONNULL_BEGIN

@interface FullMaskView : UIView<PlayerViewProtocol>

@property (nonatomic, strong) UIButton *lockBtn;
//手势层
@property(strong, nonatomic) PlayerGestureView *gestureView;


-(void)hiddenMaskView;
-(void)showMaskView;
//显示隐藏锁屏按钮
-(void)showLockBtn;
-(void)hiddenLockBtn;

@end

NS_ASSUME_NONNULL_END
