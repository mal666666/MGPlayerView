//
//  FullMaskLockView.h
//  playerView
//
//  Created by MAL on 2020/5/12.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FullMaskLockView : UIView

@property (nonatomic, copy) void(^lockViewTapBlock)(void);

@end

NS_ASSUME_NONNULL_END
