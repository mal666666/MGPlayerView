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

NS_ASSUME_NONNULL_BEGIN

@interface SmallMaskView : UIView<PlayerViewProtocol>

//手势层
@property(strong, nonatomic) PlayerGestureView *gestureView;

-(void)hiddenMaskView;
-(void)showMaskView;

@end

NS_ASSUME_NONNULL_END
