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

+ (void)getUserInfoRequestWithParams:(NSMutableDictionary *)params SuccessBlock:(void (^)(id))successBlock FailBlock:(void (^)(NSError *))failBlock{
    NSString *url = @"user_info";
    
    [AJAFNetWorkingTool postRequestWithUrl:url WithParams:params SuccessBlock:^(id object) {
        successBlock(object);
    } FailBlock:^(NSError *error) {
        failBlock(error);
    }];
}

+ (void)uploadIconRequestWithParams:(NSMutableDictionary *)params WithImageArray:(NSArray *)imageArray SuccessBlock:(void (^)(id))successBlock FailBlock:(void (^)(NSError *))failBlock{
    NSString *url = @"update_user_img";
    
    [AJAFNetWorkingTool imagesUploadWithUrl:url WithParams:params WithImageArray:imageArray SuccessBlock:^(id object) {
        successBlock(object);
    } FailBlock:^(NSError *error) {
        failBlock(error);
    }];
}

+ (void)changeNickNameRequestWithParams:(NSMutableDictionary *)params SuccessBlock:(void (^)(id))successBlock FailBlock:(void (^)(NSError *))failBlock{
    NSString *url = @"update_user_name";
    
    [AJAFNetWorkingTool postRequestWithUrl:url WithParams:params SuccessBlock:^(id object) {
        successBlock(object);
    } FailBlock:^(NSError *error) {
        failBlock(error);
    }];

}

+ (void)changeSigntureRequestWithParams:(NSMutableDictionary *)params SuccessBlock:(void (^)(id))successBlock FailBlock:(void (^)(NSError *))failBlock{
    NSString *url = @"update_user_introduction";
    
    [AJAFNetWorkingTool postRequestWithUrl:url WithParams:params SuccessBlock:^(id object) {
        successBlock(object);
    } FailBlock:^(NSError *error) {
        failBlock(error);
    }];

}

@end
