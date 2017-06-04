//
//  AJSchoolClub+Request.h
//  SC
//
//  Created by 潘安静 on 2017/6/4.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchoolClub.h"

@interface AJSchoolClub (Request)


+ (void)newClubWithParams:(NSMutableDictionary *)param
           WithImageArray:(NSArray *)imageArray
             SuccessBlock:(void(^)(id))successBlock
                FailBlock:(void(^)(NSError *))failBlock;

@end
