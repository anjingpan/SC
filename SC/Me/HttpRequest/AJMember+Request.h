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

@end
