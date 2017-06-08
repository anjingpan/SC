//
//  AJNotification.h
//  SC
//
//  Created by 潘安静 on 2017/6/7.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AJMember.h"
#import "AJSchoolClub.h"

@interface AJNotification : NSObject

@property (nonatomic, strong) NSString *msg_id;
@property (nonatomic, strong) NSString *msg_form;
@property (nonatomic, strong) NSString *send_time;
@property (nonatomic, strong) NSString *msg_to;
@property (nonatomic, strong) NSString *text_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *is_read;
@property (nonatomic, strong) NSString *Ugroup_id;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *group_id;
@property (nonatomic, strong) NSString *Departmentid;
@property (nonatomic, strong) NSString *status;             /**< 审核状态，0为未读，1为通过，-1为拒绝*/
@property (nonatomic, strong) NSString *apply_time;
@property (nonatomic, strong) NSString *handle_time;
@property (nonatomic, strong) NSString *introduce;
@property (nonatomic, strong) NSString *type;               /**< 消息类型，接收还是发送的*/
@property (nonatomic, strong) AJMember *user_info;          /**< 用户信息*/
@property (nonatomic, strong) AJSchoolClub *group_info;     /**< 社团信息*/

@end
