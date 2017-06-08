//
//  AJSchedule.h
//  SC
//
//  Created by 潘安静 on 2017/6/8.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJSchedule : NSObject

@property (nonatomic, strong) NSString *schedule_id;
@property (nonatomic, strong) NSString *group_id;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *contentText;            /**< 日程中文字*/
@property (nonatomic, strong) NSArray *contentImageArray;       /**< 日程中图片数组*/
@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong) NSString *schedule_time;
@property (nonatomic, strong) NSString *add_time;

@end
