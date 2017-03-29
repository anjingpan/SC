//
//  UITabBar+TrackPoint.h
//  SC
//
//  Created by mac on 17/3/29.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (TrackPoint)

/**
 添加小红点

 @param index  item所在的index
 @param number tabbar上的个数
 */
- (void)addTrackPointWithItemIndex:(NSInteger)index tabBarNum:(NSInteger)number;


/**
 去除小红点

 @param index item所在的index
 */
- (void)removeTrackPointWithItemIndex:(NSInteger)index;

@end
