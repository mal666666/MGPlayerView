//
//  MGAppDelegate.m
//  MGPlayerView
//
//  Created by mal666666@163.com on 05/19/2020.
//  Copyright (c) 2020 mal666666@163.com. All rights reserved.
//

#import "MGAppDelegate.h"
#import "MGNavigationController.h"
#import "MGViewController.h"

@implementation MGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    MGNavigationController *vc = [[MGNavigationController alloc]
                                  initWithRootViewController:[[MGViewController alloc]init]];
    self.window.rootViewController = vc;
    return YES;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if ([[window.rootViewController presentedViewController]
         isKindOfClass:NSClassFromString(@"PlayerFullScreenViewController")]){
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else {
        return UIInterfaceOrientationMaskPortrait;
    }
}


@end
