//
//  NSTimer+timerBlock.h
//  CNPlayerUI
//
//  Created by Mac on 2019/10/14.
//  Copyright © 2019 马 爱林. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (timerBlock)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(void(^)(void))block
                                    repeats:(BOOL)repeats;

+ (NSTimer *)scheduledTimerWithTimeIntervalNotEmpty:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

@end

NS_ASSUME_NONNULL_END
