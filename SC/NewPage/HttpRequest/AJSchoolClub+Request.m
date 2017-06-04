//
//  AJSchoolClub+Request.m
//  SC
//
//  Created by 潘安静 on 2017/6/4.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchoolClub+Request.h"
#import "AJAFNetWorkingTool.h"

@implementation AJSchoolClub (Request)

+ (void)newClubWithParams:(NSMutableDictionary *)param
           WithImageArray:(NSArray *)imageArray
             SuccessBlock:(void(^)(id))successBlock
                FailBlock:(void(^)(NSError *))failBlock{
    NSString *url = @"add_group";
    [AJAFNetWorkingTool imagesUploadWithUrl:url WithParams:param WithImageArray:imageArray SuccessBlock:^(id object) {
        successBlock(object);
    } FailBlock:^(NSError *error) {
        failBlock(error);
    }];
}

@end
