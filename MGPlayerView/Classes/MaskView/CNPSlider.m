//
//  CNPSlider.m
//  CNPlayerUI
//
//  Created by Mac on 2019/9/29.
//  Copyright © 2019 马 爱林. All rights reserved.
//

#import "CNPSlider.h"

@implementation CNPSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    rect.origin.x = rect.origin.x - 2 ;
    rect.size.width = rect.size.width +4;
    CGRect re =[super thumbRectForBounds:bounds trackRect:rect value:value];
    return CGRectInset (re, -10 , -10);
}

-(CGRect)trackRectForBounds:(CGRect)bounds {
    float h = self.sliderHeight ? self.sliderHeight : 2;
    bounds.origin.y = bounds.origin.y + (bounds.size.height-h-1)/2;
    bounds.size.height= h;
    self.layer.cornerRadius = self.sliderHeight ? self.sliderHeight/2 : 1;
    return bounds;
}

@end
