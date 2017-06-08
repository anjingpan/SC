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

//处理审核消息
+ (void)handleCheckRequestWithParams:(NSMutableDictionary *)params
                        SuccessBlock:(void(^)(id))successBlock
                           FailBlock:(void(^)(NSError *))failBlock;


//发送通知
+ (void)sendNotiRequestWithParams:(NSMutableDictionary *)params
                     SuccessBlock:(void(^)(id))successBlock
                        FailBlock:(void(^)(NSError *))failBlock;

//获取通知消息列表
+ (void)getNotiListRequestWithParams:(NSMutableDictionary *)params
                    SuccessBlock:(void(^)(id))successBlock
                       FailBlock:(void(^)(NSError *))failBlock;

//标志已读
+ (void)readNotiRequestWithParams:(NSMutableDictionary *)params
                     SuccessBlock:(void(^)(id))successBlock
                        FailBlock:(void(^)(NSError *))failBlock;

//获取已读未读信息
+ (void)getReadListRequestWithParams:(NSMutableDictionary *)params
                        SuccessBlock:(void(^)(id))successBlock
                           FailBlock:(void(^)(NSError *))failBlock;


@end
