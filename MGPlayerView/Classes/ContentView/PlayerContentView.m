//
//  PlayerContentView.m
//  playerView
//
//  Created by MAL on 2020/5/9.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import "PlayerContentView.h"


@interface PlayerContentView ()

@end

@implementation PlayerContentView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}
 
- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

-(void)playWithUrl:(NSString *)url{
    self.playerLayer.player =[[AVPlayer alloc]initWithURL:[NSURL URLWithString:url]];
    [self.playerLayer.player play];
}

@end
