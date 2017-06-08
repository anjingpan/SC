//
//  AJSchedule+HttpRequest.m
//  SC
//
//  Created by 潘安静 on 2017/6/8.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchedule+HttpRequest.h"
#import "AJAFNetWorkingTool.h"

@implementation AJSchedule (HttpRequest)

+ (void)newScheduleRequestWithParams:(NSMutableDictionary *)params WithImageArray:(NSArray *)imageArray SuccessBlock:(void (^)(id))successBlock FailBlock:(void (^)(NSError *))failBlock{
    NSString *url = @"add_schedule";
    
    [AJAFNetWorkingTool imagesUploadWithUrl:url WithParams:params WithImageArray:imageArray SuccessBlock:^(id object) {
        successBlock(object);
    } FailBlock:^(NSError *error) {
        failBlock(error);
    }];
}


+ (void)getScheduleRequestWithParams:(NSMutableDictionary *)params SuccessBlock:(void (^)(id))successBlock FailBlock:(void (^)(NSError *))failBlock{
    NSString *url = @"get_schedule";
    [AJAFNetWorkingTool postRequestWithUrl:url WithParams:params SuccessBlock:^(id object) {
        successBlock(object);
    } FailBlock:^(NSError *error) {
        failBlock(error);
    }];
}

@end
