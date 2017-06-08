//
//  AJMessageUnread+HttpRequest.m
//  SC
//
//  Created by 潘安静 on 2017/6/8.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJMessageUnread+HttpRequest.h"
#import "AJAFNetWorkingTool.h"

@implementation AJMessageUnread (HttpRequest)

+ (void)getUnreadCountRequestWithParams:(NSMutableDictionary *)params SuccessBlock:(void (^)(id))successBlock FailBlock:(void (^)(NSError *))failBlock{
    NSString *url = @"home_list";
    
    [AJAFNetWorkingTool postRequestWithUrl:url WithParams:params SuccessBlock:^(id object) {
        successBlock(object);
    } FailBlock:^(NSError *error) {
        failBlock(error);
    }];
}

@end
