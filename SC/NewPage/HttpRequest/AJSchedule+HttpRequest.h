//
//  AJSchedule+HttpRequest.h
//  SC
//
//  Created by 潘安静 on 2017/6/8.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchedule.h"

@interface AJSchedule (HttpRequest)

//新建日程
+ (void) newScheduleRequestWithParams:(NSMutableDictionary *)params
                       WithImageArray:(NSArray *)imageArray
                         SuccessBlock:(void(^)(id))successBlock
                            FailBlock:(void(^)(NSError *))failBlock;


+ (void) getScheduleRequestWithParams:(NSMutableDictionary *)params
                         SuccessBlock:(void(^)(id))successBlock
                            FailBlock:(void(^)(NSError *))failBlock;;

@end
