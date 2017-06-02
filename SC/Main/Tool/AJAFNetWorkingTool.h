//
//  AJAFNetWorkingTool.h
//  SC
//
//  Created by 潘安静 on 2017/6/1.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJAFNetWorkingTool : NSObject

+ (void)getRequestWithUrl:(NSString *)url
               WithParams:(NSMutableDictionary *)param
             SuccessBlock:(void (^)(id))successBlock
                FailBlock:(void(^)(NSError *))failBlock;

+ (void)postRequestWithUrl:(NSString *)url
                WithParams:(NSMutableDictionary *)param
              SuccessBlock:(void (^)(id))successBlock
                 FailBlock:(void(^)(NSError *))failBlock;

+ (void)imagesUploadWithUrl:(NSString *)url
                 WithParams:(NSMutableDictionary *)param
             WithImageArray:(NSArray *)imageArray
               SuccessBlock:(void(^)(id))successBlock
                  FailBlock:(void(^)(NSError *))failBlock;

@end
