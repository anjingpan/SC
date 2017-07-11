//
//  UIImageView+RoundRect.m
//  SC
//
//  Created by 潘安静 on 2017/5/27.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "UIImageView+RoundRect.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (RoundRect)

- (void)setRoundImageUrlStr:(NSString *)urlStr placeholder:(UIImage *)placeholderImage WithCornerRadius:(CGFloat)cornerRadius completed:(void(^)(BOOL))complete{
    if (placeholderImage == nil) {
        placeholderImage = [UIImage imageNamed:@"Me_Placeholder"];
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];

    if (cornerRadius == 0) {
        cornerRadius = self.frame.size.width * 0.5;
    }
    
    //添加圆角图片的尺寸，本程序中有多种尺寸不同的相同图标
    NSString *cacheRoundStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"roundCache_%.0f",cornerRadius]];
    
    UIImage *cacheRoundImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheRoundStr];
    if (cacheRoundImage) {
        self.image = cacheRoundImage;
        //有缓存直接设置为完成,添加判断因为有时候 complete 为 nil
        if (complete) {
            complete(true);
        }
    }else{
        [self sd_setImageWithURL:url placeholderImage:placeholderImage options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error) {
                self.image = image;
                [self addRoundRectWithCornerRadius:cornerRadius];
                [[SDImageCache sharedImageCache] storeImage:self.image forKey:cacheRoundStr completion:nil];
                [[SDImageCache sharedImageCache] removeImageForKey:urlStr withCompletion:nil];
                
                if (complete) {
                    complete(true);
                }
            }else{
                if (complete) {
                    complete(false);
                }
            }
            
        }];
    }
    
}

//一定要先设置图片再设置圆角，该方法是通过重绘图片来达到圆角效果
- (void)addRoundRectWithCornerRadius:(CGFloat)cornerRadius{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius] addClip];
    [self drawRect:self.bounds];
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
