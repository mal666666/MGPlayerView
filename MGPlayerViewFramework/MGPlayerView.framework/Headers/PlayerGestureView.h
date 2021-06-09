//
//  PlayerGestureView.h
//  playerView
//
//  Created by MAL on 2020/5/9.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PlayerGesturePinchType){
    PlayerGesturePinchType_AspectFill = 0,
    PlayerGesturePinchType_Aspect,
};

@protocol CNPlayerGestureViewDelegate <NSObject>

@optional
- (void)playerGesturePinchEventType:(PlayerGesturePinchType)type;
- (void)playerGestureOneTapEvent;
- (void)playerGestureDoubleTapEvent;
- (void)playerGesturePanEventLocationOffsetX:(CGFloat)offsetX;
- (void)playerGesturePanEndEvent;

@end

@interface PlayerGestureView : UIView

//@property (nonatomic, weak) id<CNPlayerGestureViewDelegate> delegate;
@property (nonatomic, strong, readonly) NSPointerArray *delegates;
- (void)addGestureViewDelegate:(id)delegate;
- (void)removeGestureViewDelegate:(id)delegate;

// 亮度，音量，快进，手势
- (void)addPanGestureRecognizer;
// 捏合，拉伸视频
- (void)addPinchGestureRecognizer;
// 单击双击手势
- (void)addTapGestureRecognizer;

- (void)removePanGestureRecognizer;
- (void)removePinchGestureRecognizer;
- (void)removeTapGestureRecognizer;

- (void)addGestureRecognizer;
- (void)removeGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
