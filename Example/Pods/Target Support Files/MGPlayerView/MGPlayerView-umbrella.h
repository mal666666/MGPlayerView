#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSString+customTime.h"
#import "NSTimer+timerBlock.h"
#import "PlayerContentView.h"
#import "BrightnessView.h"
#import "PlayerGestureView.h"
#import "MGPlayerView+Base.h"
#import "MGPlayerView+Property.h"
#import "MGPlayerView.h"
#import "PlayerFullScreenRotateAnimator.h"
#import "PlayerFullScreenViewController.h"
#import "CNPSlider.h"
#import "FullMaskLockView.h"
#import "FullMaskView.h"
#import "SmallMaskView.h"
#import "PlayerViewCallbackProtocol.h"
#import "PlayerViewProtocol.h"
#import "PlayerView_prv.h"

FOUNDATION_EXPORT double MGPlayerViewVersionNumber;
FOUNDATION_EXPORT const unsigned char MGPlayerViewVersionString[];

