//
//  AJNotification+HttpRequest.h
//  SC
//
//  Created by 潘安静 on 2017/6/7.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNotification.h"

@interface AJNotification (HttpRequest)


//请求审核消息列表
+ (void)getCheckRequestWithParams:(NSMutableDictionary *)params
                     SuccessBlock:(void(^)(id))successBlock
                        FailBlock:(void(^)(NSError *))failBlock;

+ (void)handleCheckRequestWithParams:(NSMutableDictionary *)params
                        SuccessBlock:(void(^)(id))successBlock
                           FailBlock:(void(^)(NSError *))failBlock;

@end
