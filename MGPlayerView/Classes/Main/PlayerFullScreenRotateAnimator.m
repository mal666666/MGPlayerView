//
//  PlayerFullScreenRotateAnimator.m
//  playerView
//
//  Created by Mac on 2020/5/8.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import "PlayerFullScreenRotateAnimator.h"

@interface PlayerFullScreenRotateAnimator()

@property (nonatomic, assign) CGRect originalRect;//原始playerView的frame
@property (nonatomic, strong) UIView *playerSuperView;//半屏时playerView的父view
@property (nonatomic, assign) CGPoint point;//playerView中心点在被遮挡的VC中的位置

@end

@implementation PlayerFullScreenRotateAnimator

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    _originalRect =self.playerView.frame;
    _point =[self.playerView.superview convertPoint:self.playerView.center toView:presenting.view];
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return .3 ;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.frame = containerView.bounds;
    [containerView addSubview:toViewController.view];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromViewController.view.frame = containerView.bounds;
    [containerView addSubview:fromViewController.view];

    UIView* playView = self.playerView;
    BOOL isPresent = [fromViewController.presentedViewController isEqual:toViewController];

    if (isPresent) {
        self.playerSuperView =playView.superview;
        [containerView bringSubviewToFront:fromViewController.view];
        CGSize size = containerView.frame.size;
        [playView removeFromSuperview];
        [fromViewController.view addSubview:playView];
        [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size.width));
            make.height.equalTo(@(size.height));
            make.center.equalTo(playView.superview);
        }];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            [playView.superview layoutIfNeeded];
            switch ([UIDevice currentDevice].orientation) {
                case UIInterfaceOrientationLandscapeLeft:
                    playView.transform = CGAffineTransformMakeRotation(-M_PI_2);
                    break;
                default:
                    playView.transform = CGAffineTransformMakeRotation(M_PI_2);
                    break;
            }
            toViewController.view.backgroundColor = [UIColor blackColor];
        } completion:^(BOOL finished) {
            [playView removeFromSuperview];
            [toViewController.view addSubview:playView];
            playView.transform = CGAffineTransformMakeRotation(0);
            [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(toViewController.view).insets(UIEdgeInsetsZero);
            }];

            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!wasCancelled];
        }];
    }else{
        [containerView bringSubviewToFront:fromViewController.view];
        [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.originalRect.size.width));
            make.height.equalTo(@(self.originalRect.size.height));
            if (fromViewController.view.frame.origin.x ==0) {
                make.centerX.equalTo(playView.superview).offset(-(containerView.frame.size.height/2 - self.point.y));
                make.centerY.equalTo(playView.superview).offset(containerView.frame.size.width/2 - self.point.x);
            }else{
                make.centerX.equalTo(playView.superview).offset(containerView.frame.size.height/2 - self.point.y);
                make.centerY.equalTo(playView.superview).offset(-(containerView.frame.size.width/2 - self.point.x));
            }
        }];

        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            [playView.superview layoutIfNeeded];
            if (fromViewController.view.frame.origin.x ==0) {
                playView.transform = CGAffineTransformMakeRotation(-M_PI_2);
            }else{
                playView.transform = CGAffineTransformMakeRotation(M_PI_2);
            }
            fromViewController.view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [playView removeFromSuperview];
            [self.playerSuperView addSubview:playView];
            playView.transform = CGAffineTransformMakeRotation(0);
            [playView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(playView.superview.mas_top).offset(self.originalRect.origin.y);
                make.left.equalTo(playView.superview.mas_left).offset(self.originalRect.origin.x);
                make.width.equalTo(@(self.originalRect.size.width));
                make.height.equalTo(@(self.originalRect.size.height));
            }];
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!wasCancelled];
        }];
    }
}

@end
