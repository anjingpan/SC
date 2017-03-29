//
//  UITabBar+TrackPoint.m
//  SC
//
//  Created by mac on 17/3/29.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "UITabBar+TrackPoint.h"

#define kTrackPointRidus 5.0f       //小红点半径
static NSInteger const kTag = 1000;//通过 tag 来去除红点

@implementation UITabBar (TrackPoint)

- (void)addTrackPointWithItemIndex:(NSInteger)index tabBarNum:(NSInteger)number{
    //防止重复添加
    [self removeTrackPointWithItemIndex:index];
    
    UILabel *trackPoint = [[UILabel alloc] init];
    trackPoint.tag = kTag + index;
    trackPoint.layer.cornerRadius = kTrackPointRidus;
    trackPoint.layer.masksToBounds = YES;
    trackPoint.backgroundColor = [UIColor redColor];
    
    CGFloat tabBarWidth = CGRectGetWidth(self.frame) / number;
    trackPoint.frame = CGRectMake((index + 0.6) * tabBarWidth, 0.1 * CGRectGetHeight(self.frame), 2 * kTrackPointRidus, 2 * kTrackPointRidus);
    
    [self addSubview:trackPoint];
    [self bringSubviewToFront:trackPoint];
}

- (void)removeTrackPointWithItemIndex:(NSInteger)index{
    for (UIView *subView in self.subviews) {
        if (subView.tag == kTag + index) {
            [subView removeFromSuperview];
        }
    }
}

@end
