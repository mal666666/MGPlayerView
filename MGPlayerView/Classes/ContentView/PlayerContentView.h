//
//  PlayerContentView.h
//  playerView
//
//  Created by MAL on 2020/5/9.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerContentView : UIView

@property (strong, nonatomic) AVPlayerLayer *playerLayer;

-(void)playWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
