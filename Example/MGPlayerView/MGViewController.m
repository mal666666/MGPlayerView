//
//  MGViewController.m
//  MGPlayerView
//
//  Created by mal666666@163.com on 05/19/2020.
//  Copyright (c) 2020 mal666666@163.com. All rights reserved.
//

#import "MGViewController.h"
#import <PlayerView.h>

@interface MGViewController ()<PlayerViewUICallbackProtocol>

@end

@implementation MGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    PlayerView *playerView =[[PlayerView alloc]initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.width *9/16)];
    [self.view addSubview:playerView];
    [playerView setPlayUrl:@"http://stream1.shopch.jp/HLS/out1/prog_index.m3u8"];
    //[playerView setPlayUrl:@"http://154.8.159.252:7301/group1/M00/00/00/CqMY9F82TA2EKVz1AAAAAECmKyk899.mp4"];
    [playerView supportFullScreenWithVC:self];
    playerView.delegateUI =self;
    [playerView play];

}

-(void)smallMaskViewBackEvent:(id)playerView{
    NSLog(@"退出视频");
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
