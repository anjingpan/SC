//
//  AJSchoolClub.m
//  SC
//
//  Created by 潘安静 on 2017/6/4.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchoolClub.h"
#import "AJMember.h"

@implementation AJSchoolClub

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"user_list" : [AJMember class]};
}

@end
