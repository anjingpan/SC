//
//  AJMessageUnread.h
//  SC
//
//  Created by 潘安静 on 2017/6/8.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJMessageInfo.h"

@interface AJMessageUnread : NSObject

@property (nonatomic, strong)NSString *msg_count;
@property (nonatomic, strong)AJMessageInfo *msg_info;
@property (nonatomic, strong)NSString *apply_count;
@property (nonatomic, strong)AJMessageInfo *apply_info;
@property (nonatomic, strong)NSString *system_msg;
@property (nonatomic, strong)AJMessageInfo *systme_info;

@end
