//
//  UIImageView+RoundRect.m
//  SC
//
//  Created by 潘安静 on 2017/5/27.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "UIImageView+RoundRect.h"

@implementation UIImageView (RoundRect)

//一定要先设置图片再设置圆角，该方法是通过重绘图片来达到圆角效果
- (void)addRoundRectWithCornerRadius:(CGFloat)cornerRadius{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius] addClip];
    [self drawRect:self.bounds];
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
