//
//  UIImageView+RoundRect.h
//  SC
//
//  Created by 潘安静 on 2017/5/27.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (RoundRect)

//用 SDWebImage加载网络图片实现圆角图片视图
- (void)setRoundImageUrlStr:(NSString *)urlStr placeholder:(UIImage *)placeholderImage WithCornerRadius:(CGFloat)cornerRadius;

//圆角图片视图实现
- (void)addRoundRectWithCornerRadius:(CGFloat)cornerRadius;

@end
