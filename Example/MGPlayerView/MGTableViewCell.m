//
//  MGTableViewCell.m
//  MGPlayerView_Example
//
//  Created by kl-ios on 2022/8/13.
//  Copyright © 2022 mal666666@163.com. All rights reserved.
//

#import "MGTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface MGTableViewCell ()

@property (strong, nonatomic)UIImageView *imgIV;

@end

@implementation MGTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.imgIV = [[UIImageView alloc] initWithFrame:CGRectMake(16, 8, 160, 80-16)];
    self.imgIV.contentMode = UIViewContentModeScaleAspectFit;
    self.imgIV.clipsToBounds = YES;
    [self.contentView addSubview: _imgIV];
    return self;
}

- (void)setImg:(NSString *)imgStr {
    [self thumbnailImageForVideo:[NSURL URLWithString:imgStr] atTime:0 success:^(UIImage *img) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgIV.image = img;
        });
    }];
}

- (void)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time success:(void(^)(UIImage *img))success {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = time;
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
        if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
        UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
        success(thumbnailImage);
    });
}

@end
