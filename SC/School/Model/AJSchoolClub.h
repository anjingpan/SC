//
//  AJSchoolClub.h
//  SC
//
//  Created by 潘安静 on 2017/6/4.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJSchoolClub : NSObject

@property (nonatomic, strong)NSString *Groupid;         /**< 社团 ID*/
@property (nonatomic, strong)NSString *Groupname;       /**< 社团名称*/
@property (nonatomic, strong)NSString *GroupManager;    /**< 社团管理员 ID*/
@property (nonatomic, strong)NSString *GroupSchool;     /**< 社团所在学校*/
@property (nonatomic, strong)NSString *introduction;    /**< 社团简介*/
@property (nonatomic, strong)NSString *imgurl;          /**< 社团头像链接*/

@end
