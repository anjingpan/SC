//
//  AJNotification+HttpRequest.m
//  SC
//
//  Created by 潘安静 on 2017/6/7.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNotification+HttpRequest.h"
#import "AJAFNetWorkingTool.h"

@implementation AJNotification (HttpRequest)

+ (void)getCheckRequestWithParams:(NSMutableDictionary *)params SuccessBlock:(void (^)(id))successBlock FailBlock:(void (^)(NSError *))failBlock{
    NSString *url = @"apply_list";
    
    [AJAFNetWorkingTool postRequestWithUrl:url WithParams:params SuccessBlock:^(id object) {
        successBlock(object);
    } FailBlock:^(NSError *error) {
        failBlock(error);
    }];
}

+ (void)handleCheckRequestWithParams:(NSMutableDictionary *)params SuccessBlock:(void (^)(id))successBlock FailBlock:(void (^)(NSError *))failBlock{
    NSString *url = @"handle_apply";
    
    [AJAFNetWorkingTool postRequestWithUrl:url WithParams:params SuccessBlock:^(id object) {
        successBlock(object);
    } FailBlock:^(NSError *error) {
        failBlock(error);
    }];
}

@end
