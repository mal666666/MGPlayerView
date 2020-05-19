//
//  FullMaskLockView.m
//  playerView
//
//  Created by MAL on 2020/5/12.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import "FullMaskLockView.h"

@implementation FullMaskLockView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)tapClick{
    if (self.lockViewTapBlock) {
        self.lockViewTapBlock();
    }
}

@end
