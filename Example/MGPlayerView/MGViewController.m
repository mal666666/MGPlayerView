//
//  MGViewController.m
//  MGPlayerView
//
//  Created by mal666666@163.com on 05/19/2020.
//  Copyright (c) 2020 mal666666@163.com. All rights reserved.
//

#import "MGViewController.h"
#import <MGPlayerView/MGPlayerView.h>

@interface MGViewController ()<PlayerViewUICallbackProtocol>

@end

@implementation MGViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor grayColor];
    MGPlayerView *playerView =[[MGPlayerView alloc]initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.width *9/16)];
    [self.view addSubview:playerView];
    [playerView setPlayUrl:@"http://stream1.shopch.jp/HLS/out1/prog_index.m3u8"];
    [playerView setPlayUrl:@"http://mm.pushitongda.com:9999/ipfs/Qmd6cN231gVhRKw5seG2SpzS7GtFHZfkYzEVXf4GpASout"];
    [playerView setPlayUrl:@"http://www.malgg.com/aaa/video.mp4"];
    [playerView supportFullScreenWithVC:self];
//    [playerView activityIndicaHidden:YES];
    playerView.delegateUI =self;
    [playerView play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1500 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [playerView quitSmallScreen];
    });
}
#pragma mark --- PlayerViewUICallbackProtocol  ---
-(void)playStateEvent:(id)view state:(BOOL)isPlaying{
    NSLog(@"%@",isPlaying?@"播放":@"暂停");
}

-(void)smallMaskViewBackEvent:(id)playerView{
    NSLog(@"退出视频");
}

-(void)smallMaskViewToFullScreenEvent:(id)playerView completion:(void (^)(void))completion{
    NSLog(@"去大屏");
}

-(void)fullMaskViewBackEvent:(id)playerView completion:(void (^)(void))completion{
    NSLog(@"去小屏");
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
