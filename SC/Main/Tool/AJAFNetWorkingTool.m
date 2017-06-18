//
//  AJAFNetWorkingTool.m
//  SC
//
//  Created by 潘安静 on 2017/6/1.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJAFNetWorkingTool.h"
#import <AFNetworking.h>
#import "AJProfile.h"

static AFHTTPSessionManager *sessionManager = nil;

@implementation AJAFNetWorkingTool

+ (id) sharedHttpSessionManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[AFHTTPSessionManager alloc] init];
    });
    
    return sessionManager;
}

+ (void)getRequestWithUrl:(NSString *)url
               WithParams:(NSMutableDictionary *)param
             SuccessBlock:(void (^)(id))successBlock
                FailBlock:(void(^)(NSError *))failBlock{
    NSString *urlStr = [CONST_URL stringByAppendingString:url];
    
    NSMutableDictionary *params = [self addConstParams:param];
    
    AFHTTPSessionManager *manager = [self sharedHttpSessionManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"errcode"] isEqualToString:@"0"] || responseObject[@"errcode"] == 0) {
            successBlock(responseObject);
        }else{
            failBlock([NSError errorWithDomain:@"AJAppError" code:[responseObject[@"errcode"] integerValue] userInfo:@{NSLocalizedDescriptionKey : responseObject[@"errmsg"]}]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}


+ (void)postRequestWithUrl:(NSString *)url
                WithParams:(NSMutableDictionary *)param
              SuccessBlock:(void (^)(id))successBlock
                 FailBlock:(void(^)(NSError *))failBlock{
    NSString *urlStr = [CONST_URL stringByAppendingString:url];
    NSLog(@"url--%@",urlStr);
    
    NSMutableDictionary *params = [self addConstParams:param];
    
    NSLog(@"params--%@",params);
    AFHTTPSessionManager *manager = [self sharedHttpSessionManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ( [responseObject[@"errcode"] integerValue] == 0) {
            successBlock(responseObject);
        }else{
            failBlock([NSError errorWithDomain:@"AJAppError" code:[responseObject[@"errcode"] integerValue] userInfo:@{NSLocalizedDescriptionKey : responseObject[@"errmsg"]}]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}


+ (void)imagesUploadWithUrl:(NSString *)url
                 WithParams:(NSMutableDictionary *)param
             WithImageArray:(NSArray *)imageArray
               SuccessBlock:(void(^)(id))successBlock
                  FailBlock:(void(^)(NSError *))failBlock{
    NSString *urlStr = [CONST_URL stringByAppendingString:url];
    
    NSMutableDictionary *params = [self addConstParams:param];
    NSLog(@"%@",params);
    
    AFHTTPSessionManager *manager = [self sharedHttpSessionManager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    //保证图片数组不为空
    imageArray = imageArray ? :[NSArray array];
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imageArray.count; i ++) {
            //图片压缩比例0.5；
            NSData *imageData = UIImageJPEGRepresentation(imageArray[i], 0.5);
            [formData appendPartWithFileData:imageData name:@"imgurl" fileName:[NSString stringWithFormat:@"image_%i.png",i + 1] mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"errcode"] integerValue] == 0) {
            successBlock(responseObject);
        }else{
            failBlock([NSError errorWithDomain:@"AJAppError" code:[responseObject[@"errcode"] integerValue] userInfo:@{NSLocalizedDescriptionKey : responseObject[@"errmsg"]}]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
    
    
}

+ (NSMutableDictionary *)addConstParams:(NSMutableDictionary *)param{
    param = param ? : [NSMutableDictionary dictionary];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_TOKEN_KEY];
    if (token) {
        param[@"access_token"] = param[@"token"] ? : token;
    }
    
    param[@"appOrigin"] = @"AJ_iOS";
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    param[@"phoneType"] = systemVersion;
    
    NSString *key = @"CFBundleVersion";
    NSString *currentVesion = [NSBundle mainBundle].infoDictionary[key];
    param[@"version"] = currentVesion;
    
    param[@"pageSize"] = param[@"pageSize"] ? : @(10);
    
    return param;
}

@end
