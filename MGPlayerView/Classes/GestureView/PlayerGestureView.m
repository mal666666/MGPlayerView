//
//  PlayerGestureView.m
//  playerView
//
//  Created by MAL on 2020/5/9.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import "PlayerGestureView.h"
#import "PlayerView_prv.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BrightnessView.h"

@interface PlayerGestureView ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture; // 亮度，音量，快进，手势控制
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture; // 捏合，拉伸视频
@property (nonatomic, strong) UITapGestureRecognizer *oneTapGesture; // 单击手势
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture; // 双击手势
@property (nonatomic, assign) float gestureMinimumTranslation;

@property (nonatomic, assign) CameraMoveDirection  direction; //方向
@property (nonatomic, assign) CGPoint startLocation;    // 开始位置
@property (nonatomic, assign) CGPoint currentLocation;  // 当前改变的位置
@property (nonatomic, assign) float   systemVolume;     // 系统音量
@property (nonatomic, assign) CGFloat systemBrightness; // 系统亮度
@property (nonatomic, strong) MPVolumeView *volumeView; // 系统音量控件
@property (nonatomic, strong) UISlider *volumeViewSlider;//控制音量

@end

@implementation PlayerGestureView
@synthesize delegates = _delegates;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.gestureMinimumTranslation = 5.0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

}

// 亮度，音量，快进，手势
- (void)addPanGestureRecognizer {
    [self addGestureRecognizer:self.panGesture];
}
// 捏合，拉伸视频
- (void)addPinchGestureRecognizer {
    [self addGestureRecognizer:self.pinchGesture];
}
// 单击双击手势
- (void)addTapGestureRecognizer {
    [self addGestureRecognizer:self.oneTapGesture];
    [self addGestureRecognizer:self.doubleTapGesture];
    [self.oneTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
}

- (void)removePanGestureRecognizer {
    [self removeGestureRecognizer:self.panGesture];
}

- (void)removePinchGestureRecognizer {
    [self removeGestureRecognizer:self.pinchGesture];
}

- (void)removeTapGestureRecognizer {
    [self removeGestureRecognizer:self.oneTapGesture];
    [self removeGestureRecognizer:self.doubleTapGesture];
}

- (void)addGestureRecognizer {
    [self addGestureRecognizer:self.panGesture];
    [self addGestureRecognizer:self.pinchGesture];
    [self addGestureRecognizer:self.oneTapGesture];
    [self addGestureRecognizer:self.doubleTapGesture];
    [self.oneTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    
    self.volumeView.frame = self.bounds;
}

- (void)removeGestureRecognizer {
    [self removeGestureRecognizer:self.panGesture];
    [self removeGestureRecognizer:self.pinchGesture];
    [self removeGestureRecognizer:self.oneTapGesture];
    [self removeGestureRecognizer:self.doubleTapGesture];
}

#pragma mark - event response
- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (recognizer.scale > 1) {
            for (id delegate in self.delegates) {
                if ([delegate respondsToSelector:@selector(playerGesturePinchEventType:)]) {
                    [delegate playerGesturePinchEventType:PlayerGesturePinchType_AspectFill];
                }
            }
        } else {
            for (id delegate in self.delegates) {
                if ([delegate respondsToSelector:@selector(playerGesturePinchEventType:)]) {
                    [delegate playerGesturePinchEventType:PlayerGesturePinchType_Aspect];
                }
            }
        }
    }
}

- (void)oneTapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    for (id delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(playerGestureOneTapEvent)]) {
            [delegate playerGestureOneTapEvent];
        }
    }
}

- (void)doubleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    for (id delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(playerGestureDoubleTapEvent)]) {
            [delegate playerGestureDoubleTapEvent];
        }
    }
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.direction        = kCameraMoveDirectionNone; // 无方向
        self.startLocation    = [recognizer locationInView:self];// 开始滑动位置
        self.systemVolume     = self.volumeViewSlider.value;// 获取当前音量
        self.systemBrightness = [UIScreen mainScreen].brightness;// 获取当前亮度
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [recognizer translationInView:self]; // 事实移动位置 增量
        self.direction = [self determineCameraDirectionIfNeeded:translation];
        self.currentLocation = [recognizer locationInView:self];
           // 亮度/声音调节
            if (self.direction == kCameraMoveDirectionUp || self.direction == kCameraMoveDirectionDown) {
                // 亮度
                if (self.startLocation.x <= (CGRectGetWidth([UIScreen mainScreen].bounds))/3) {
                    float currentBrightness = self.systemBrightness + ((self.startLocation.y - self.currentLocation.y) / CGRectGetHeight(self.frame));
                    if (currentBrightness <= 0 ) {
                        currentBrightness = 0;
                    } else if(currentBrightness >= 1) {
                        currentBrightness = 1;
                    }
                    [[UIScreen mainScreen] setBrightness:currentBrightness];
                // 声音
                } else if (self.startLocation.x >= CGRectGetWidth(self.frame) - (CGRectGetWidth([UIScreen mainScreen].bounds))/3) {
                    float currentVolume = self.systemVolume + ((self.startLocation.y - self.currentLocation.y) / CGRectGetHeight(self.frame));
                    if (currentVolume <= 0 ) {
                        currentVolume = 0;
                    } else if(currentVolume >= 1) {
                        currentVolume = 1;
                    }
                    self.volumeViewSlider.value = currentVolume;
                }
                // 进度调节
            } else if(self.direction == kCameraMoveDirectionRight || self.direction == kCameraMoveDirectionLeft) {
                float x = 60;//下面区域手势放弃
                if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){x =100;}
                if (self.currentLocation.y >= (CGRectGetHeight(self.frame) - x)) {return;}
                if ([self respondsToSelector:@selector(panGestureTouchValueChangeWithTranslationX:)]) {
                    [self panGestureTouchValueChangeWithTranslationX:translation.x];
                }
            }
    }else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if(self.direction == kCameraMoveDirectionRight || self.direction == kCameraMoveDirectionLeft) {
            float x = 60;//下面区域手势放弃
            if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){x =100;}
            if (self.currentLocation.y >= (CGRectGetHeight(self.frame) - x)) {return;}
            if ([self respondsToSelector:@selector(panGestureTouchEnded)]) {
                [self panGestureTouchEnded];
            }
        }
     }
}

#pragma mark - private method
- (CameraMoveDirection )determineCameraDirectionIfNeeded:(CGPoint )translation {//获取方向
    if (self.direction != kCameraMoveDirectionNone)
        return self.direction;
    if (fabs(translation.x) > self.gestureMinimumTranslation) {
        BOOL gestureHorizontal = NO;
        if (translation.y == 0.0) {
            gestureHorizontal = YES;
        }else {
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
        }
        if (gestureHorizontal) {
            if (translation.x > 0.0) {
                return kCameraMoveDirectionRight;
            }else {
                return kCameraMoveDirectionLeft;
            }
        }
    }else if (fabs(translation.y) > self.gestureMinimumTranslation) {
        BOOL gestureVertical = NO;
        if (translation.x == 0.0) {
            gestureVertical = YES;
        }else {
            gestureVertical = (fabs(translation.y / translation.x) > 5.0);
        }
        if (gestureVertical) {
            if (translation.y > 0.0) {
                return kCameraMoveDirectionDown;
            }else {
                return kCameraMoveDirectionUp;
            }
        }
    }
    return self.direction;
}

-(void)panGestureTouchValueChangeWithTranslationX:(CGFloat)x {
    for (id delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(playerGesturePanEventLocationOffsetX:)]) {
            [delegate playerGesturePanEventLocationOffsetX:x];
        }
    }
}

-(void)panGestureTouchEnded {
    for (id delegate in self.delegates) {
        if ([delegate respondsToSelector:@selector(playerGesturePanEndEvent)]) {
            [delegate playerGesturePanEndEvent];
        }
    }
}

#pragma mark - setter & getter
- (UIPanGestureRecognizer *)panGesture{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    }
    return _panGesture;
}
- (UIPinchGestureRecognizer *)pinchGesture{
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer:)];
    }
    return _pinchGesture;
}

- (UITapGestureRecognizer *)oneTapGesture {
    if (!_oneTapGesture) {
        _oneTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapGestureRecognizer:)];
        _oneTapGesture.numberOfTouchesRequired = 1;
    }
    return _oneTapGesture;
}

- (UITapGestureRecognizer *)doubleTapGesture {
    if (!_doubleTapGesture) {
        _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizer:)];
        _doubleTapGesture.numberOfTapsRequired =2;
    }
    return _doubleTapGesture;
}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView  = [[MPVolumeView alloc] init];
        [_volumeView sizeToFit];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeView;
}

- (NSPointerArray *)delegates{
    if (!_delegates) {
        _delegates = [[NSPointerArray alloc] init];
    }
    return _delegates;
}

- (void)addGestureViewDelegate:(id)delegate {
    for (int i = 0; i < [self.delegates count]; i++) {
        void *delegateGestureView = [self.delegates pointerAtIndex:i];
        if (delegateGestureView == (__bridge void *)(delegate)) {
            return;
        }
    }
    [self.delegates addPointer:(__bridge void * _Nullable)(delegate)];
}

- (void)removeGestureViewDelegate:(id)delegate {
    int indexNeedRemoved = -1;
    for (int i = 0; i < [self.delegates count]; i++) {
        void *delegateGestureView = [self.delegates pointerAtIndex:i];
        if (delegateGestureView == (__bridge void *)(delegate)) {
            indexNeedRemoved = i;
            break;
        }
    }
    if (indexNeedRemoved > -1) {
        [self.delegates removePointerAtIndex:indexNeedRemoved];
    }
}


@end
