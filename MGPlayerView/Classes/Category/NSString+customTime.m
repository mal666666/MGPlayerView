//
//  NSString+customTime.m
//  CNPlayerUI
//
//  Created by Mac on 2019/10/28.
//  Copyright © 2019 马 爱林. All rights reserved.
//

#import "NSString+customTime.h"


@implementation NSString (customTime)

+(NSString *)customTimeWithSecond:(float )second{
    int h =second/3600;
    int m =(int)second%3600/60;
    int s =(int)second%60;
    if (h>0) {return [NSString stringWithFormat:@"%.2d:%.2d:%.2d",h,m,s];}
    return [NSString stringWithFormat:@"%.2d:%.2d",m,s];
}

@end
