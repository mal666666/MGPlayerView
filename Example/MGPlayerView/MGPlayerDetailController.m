//
//  MGPlayerDetailController.m
//  MGPlayerView_Example
//
//  Created by Mac on 2022/8/8.
//  Copyright © 2022 mal666666@163.com. All rights reserved.
//

#import "MGPlayerDetailController.h"
#import <MGPlayerView/MGPlayerView.h>

@interface MGPlayerDetailController ()<PlayerViewUICallbackProtocol>

@property (nonatomic, strong) MGPlayerView *playerView;

@end

@implementation MGPlayerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor grayColor];
    [self.navigationController supportedInterfaceOrientations];

    MGPlayerView *playerView =[[MGPlayerView alloc]initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, self.view.bounds.size.width *9/16)];
    [self.view addSubview:playerView];
    [playerView setPlayUrl:self.url];
    [playerView supportFullScreenWithVC:self];
//    [playerView activityIndicaHidden:YES];
//    [playerView deviceOrientation:NO];
    playerView.delegateUI =self;
    [playerView play];
    self.playerView = playerView;

}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![self.presentedViewController isKindOfClass:NSClassFromString(@"PlayerFullScreenViewController")]) {
        [self.playerView stop];
    }
}

#pragma mark --- PlayerViewUICallbackProtocol  ---
-(void)playStateEvent:(id)view state:(BOOL)isPlaying{
    NSLog(@"%@",isPlaying?@"播放":@"暂停");
}

-(void)smallMaskViewBackEvent:(id)playerView{
    NSLog(@"退出视频");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)smallMaskViewToFullScreenEvent:(id)playerView completion:(void (^)(void))completion{
    NSLog(@"去大屏");
}

-(void)fullMaskViewBackEvent:(id)playerView completion:(void (^)(void))completion{
    NSLog(@"去小屏");
}

@end
