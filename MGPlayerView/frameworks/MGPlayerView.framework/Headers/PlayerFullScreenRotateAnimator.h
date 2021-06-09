//
//  PlayerFullScreenRotateAnimator.h
//  playerView
//
//  Created by Mac on 2020/5/8.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerFullScreenRotateAnimator : NSObject
<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIView *playerView;

@end

NS_ASSUME_NONNULL_END
