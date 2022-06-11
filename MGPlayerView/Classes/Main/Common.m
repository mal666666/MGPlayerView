//
//  Common.m
//  MGPlayerView
//
//  Created by Mac on 2022/6/11.
//

#import "Common.h"

@implementation Common

+ (NSBundle * _Nullable)MGPlayerViewBundle {
    return [NSBundle bundleWithURL:[[[NSBundle bundleForClass:NSClassFromString(@"MGPlayerView")] resourceURL] URLByAppendingPathComponent:@"MGPlayerView.bundle"]];
}

@end
