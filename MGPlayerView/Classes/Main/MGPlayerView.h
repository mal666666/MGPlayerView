//
//  MGPlayerView.h
//  MGplayerView
//
//  Created by Mac on 2020/5/8.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerViewProtocol.h"
#import "PlayerViewCallbackProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGPlayerView : UIView<PlayerViewProtocol,PlayerViewUICallbackProtocol>


@end

NS_ASSUME_NONNULL_END
