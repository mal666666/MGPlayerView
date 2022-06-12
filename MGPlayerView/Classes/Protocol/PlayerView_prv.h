//
//  PlayerView_prv.h
//  playerView
//
//  Created by MAL on 2020/5/9.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#ifndef PlayerView_prv_h
#define PlayerView_prv_h

//图标资源
//#define PlayerView(img) [@"PlayerView.bundle/" stringByAppendingString:img]

#define  PlayerView(img)\
({\
    NSBundle *framework =[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Frameworks/MGPlayerView" ofType:@"framework"]];\
    NSBundle *bundle = [NSBundle bundleWithPath:[framework pathForResource:@"MGPlayerView" ofType:@"bundle"]];\
    NSString *path =[NSString stringWithFormat:@"%@/%@",bundle.resourcePath, img];\
    (path);\
})\

//bundle位置
#define MGPlayerViewBundle()\
({\
    NSBundle *framework = [NSBundle bundleWithURL:[[[NSBundle bundleForClass:NSClassFromString(@"MGPlayerView")] resourceURL] URLByAppendingPathComponent:@"MGPlayerView.bundle"]];\
    (framework);\
})\

//浮层消失时间
#define MaskViewHiddenWaitingTime 3
//滑动方向
typedef NS_ENUM(NSInteger, CameraMoveDirection) {
    kCameraMoveDirectionNone,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft,
};

#endif /* PlayerView_prv_h */
