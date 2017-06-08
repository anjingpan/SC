//
//  AJMessageUnread+HttpRequest.h
//  SC
//
//  Created by 潘安静 on 2017/6/8.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJMessageUnread.h"

@interface AJMessageUnread (HttpRequest)

//获取未读消息数
+ (void)getUnreadCountRequestWithParams:(NSMutableDictionary *)params
                           SuccessBlock:(void(^)(id))successBlock
                              FailBlock:(void(^)(NSError *))failBlock;

@end
