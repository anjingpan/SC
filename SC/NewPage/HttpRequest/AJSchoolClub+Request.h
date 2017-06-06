//
//  AJSchoolClub+Request.h
//  SC
//
//  Created by 潘安静 on 2017/6/4.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchoolClub.h"

@interface AJSchoolClub (Request)

//社团列表
+ (void)getSchoolClubRequestWithParams:(NSMutableDictionary *)params
                          SuccessBlock:(void(^)(id))successBlock
                             FailBlock:(void(^)(NSError *))failBlock;

//申请社团
+ (void)applySchoolClubRequestWithParams:(NSMutableDictionary *)params
                            SuccessBlock:(void(^)(id))successBlock
                               FailBlock:(void(^)(NSError *))failBlock;

//我的社团信息
+ (void)getSelfClubRequestWithParams:(NSMutableDictionary *)params
                        SuccessBlock:(void(^)(id))successBlock
                           FailBlock:(void(^)(NSError *))failBlock;

//获取社团详细信息
+ (void)getClubInfoRequestWithParams:(NSMutableDictionary *)params
                        SuccessBlock:(void(^)(id))successBlock
                           FailBlock:(void(^)(NSError *))failBlock;

//新建社团
+ (void)newClubWithParams:(NSMutableDictionary *)param
           WithImageArray:(NSArray *)imageArray
             SuccessBlock:(void(^)(id))successBlock
                FailBlock:(void(^)(NSError *))failBlock;

@end
