//
//  PlayerViewCallbackProtocol.h
//  playerView
//
//  Created by MAL on 2020/5/11.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PlayerViewCallbackProtocol <NSObject>


@end


@protocol PlayerViewUICallbackProtocol <NSObject>

@optional
//小屏返回事件
-(void)smallMaskViewBackEvent:(id)playerView;
//小屏去全屏事件
-(void)smallMaskViewToFullScreenEvent:(id)playerView completion:(void (^)(void))completion;
//全屏返回事件
-(void)fullMaskViewBackEvent:(id)playerView completion:(void (^)(void))completion;
//播放暂停事件
-(void)playBtnClickEvent:(id)view;
//锁屏按钮事件,YES为加锁，NO为解锁
-(void)lockBtnClickEventWithState:(BOOL)state;


@end


NS_ASSUME_NONNULL_END
