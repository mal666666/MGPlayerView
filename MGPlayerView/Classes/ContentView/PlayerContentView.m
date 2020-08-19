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

-(void)setPlayUrl:(NSString *)url{
    AVURLAsset *asset =[AVURLAsset assetWithURL:[NSURL URLWithString:url]];
    AVPlayerItem *item =[AVPlayerItem playerItemWithAsset:asset];
    self.playerLayer.player =[AVPlayer playerWithPlayerItem:item];
    if (@available(iOS 10.0, *)) {
        self.playerLayer.player.automaticallyWaitsToMinimizeStalling = YES;
    } else {
        // Fallback on earlier versions
    }
}

@end
