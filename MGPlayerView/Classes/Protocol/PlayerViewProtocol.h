//
//  PlayerViewProtocol.h
//  playerView
//
//  Created by MAL on 2020/5/11.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerViewCallbackProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PlayerViewProtocol <NSObject>

@optional

//浮层代理
@property (nonatomic,weak) id<PlayerViewUICallbackProtocol> delegateUI;
//播放资源
-(void)setPlayUrl:(NSString *)url;
-(void)setUrl:(NSURL *)url;
//播放
-(void)play;
//暂停
-(void)pause;
//停止
-(void)stop;
//支持全屏
-(void)supportFullScreenWithVC:(UIViewController *)vc;
//退出全屏
-(void)quitFullScreen:(void (^__nullable)(void))completion;
//进入全屏
-(void)toFullScreen:(void (^__nullable)(void))completion;
//隐藏加载中菊花
-(void)activityIndicaHidden:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
