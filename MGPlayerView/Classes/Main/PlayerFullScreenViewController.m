//
//  PlayerFullScreenViewController.m
//  playerView
//
//  Created by Mac on 2020/5/8.
//  Copyright © 2020 马 爱林. All rights reserved.
//

#import "PlayerFullScreenViewController.h"

@interface PlayerFullScreenViewController ()

@end

@implementation PlayerFullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor blackColor];
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

@end
