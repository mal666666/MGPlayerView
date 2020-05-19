//
//  NSTimer+timerBlock.m
//  CNPlayerUI
//
//  Created by Mac on 2019/10/14.
//  Copyright © 2019 马 爱林. All rights reserved.
//

#define CN_Default_TimeInterval  5

#import "NSTimer+timerBlock.h"


@implementation NSTimer (timerBlock)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats {
    if(interval <= 0){
        interval = CN_Default_TimeInterval;
    }
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)blockInvoke:(NSTimer *)timer {
    void (^ block)(NSString *s) = timer.userInfo;
    if (block) {
        block(@"e");
    }
}

+ (NSTimer *)scheduledTimerWithTimeIntervalNotEmpty:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    if(ti <= 0){
        ti = CN_Default_TimeInterval;
    }
    return [NSTimer scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

@end
