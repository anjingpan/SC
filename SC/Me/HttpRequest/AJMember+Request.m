//
//  AJMember+Request.m
//  SC
//
//  Created by 潘安静 on 2017/6/5.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJMember+Request.h"
#import "AJAFNetWorkingTool.h"

@implementation AJMember (Request)

+ (void)getContactsRequestWithParams:(NSMutableDictionary *)params SuccessBlock:(void (^)(id))successBlock FailBlock:(void (^)(NSError *))failBlock{
    NSString *url = @"contacts";
    
    [AJAFNetWorkingTool postRequestWithUrl:url WithParams:params SuccessBlock:^(id object) {
        successBlock(object);
    } FailBlock:^(NSError *error) {
        failBlock(error);
    }];
}

@end
