//
//  AJMember+Request.h
//  SC
//
//  Created by 潘安静 on 2017/6/5.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJMember.h"

@interface AJMember (Request)


//获取社团成员信息
+ (void)getContactsRequestWithParams:(NSMutableDictionary *)params
                         SuccessBlock:(void(^)(id))successBlock
                            FailBlock:(void(^)(NSError *))failBlock;

//获取用户信息
+ (void)getUserInfoRequestWithParams:(NSMutableDictionary *)params
                        SuccessBlock:(void(^)(id))successBlock
                           FailBlock:(void(^)(NSError *))failBlock;

//上传头像
+ (void)uploadIconRequestWithParams:(NSMutableDictionary *)params
                     WithImageArray:(NSArray *)imageArray
                       SuccessBlock:(void(^)(id))successBlock
                          FailBlock:(void(^)(NSError *))failBlock;
;

//修改昵称
+ (void)changeNickNameRequestWithParams:(NSMutableDictionary *)params
                           SuccessBlock:(void(^)(id))successBlock
                              FailBlock:(void(^)(NSError *))failBlock;

//修改签名
+ (void)changeSigntureRequestWithParams:(NSMutableDictionary *)params
                           SuccessBlock:(void(^)(id))successBlock
                              FailBlock:(void(^)(NSError *))failBlock;

@end
