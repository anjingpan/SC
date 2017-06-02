//
//  AJAccount+Request.h
//  SC
//
//  Created by 潘安静 on 2017/6/2.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJAccount.h"

@interface AJAccount (Request)

//发送验证码接口
+ (void) sendMessageRequestWithParams:(NSMutableDictionary *)params
                         SuccessBlock:(void(^)(id))successBlock
                            FailBlock:(void(^)(NSError *))failBlock;


//验证验证码
+ (void)checkVerifyRequestWithParams:(NSMutableDictionary *)params
                        SuccessBlock:(void(^)(id))successBlock
                           FailBlock:(void(^)(NSError *))failBlock;

//注册接口
+ (void)registerRequestWithParams:(NSMutableDictionary *)params
                     SuccessBlock:(void(^)(id))successBlock
                        FailBlock:(void(^)(NSError *))failBlock;

//登录接口
+ (void)loginRequestWithParams:(NSMutableDictionary *)params
                  SuccessBlock:(void(^)(id))successBlock
                     FailBlock:(void(^)(NSError *))failBlock;

@end
