//
//  AJProfile.h
//  SC
//
//  Created by 潘安静 on 2017/3/19.
//  Copyright © 2017年 anjing. All rights reserved.
//

#ifndef AJProfile_h
#define AJProfile_h


#endif /* AJProfile_h */

#pragma mark - const

//URL Const
static NSString *const CONST_URL = @"http://gms.lyx.name/api/";
static NSString *const CONST_URL_DOMAIN = @"http://gms.lyx.name/";

//Token Key
static NSString *const USERDEFAULT_TOKEN_KEY = @"userDefaultTokenKey";  /**< token 本地存储的 key*/
static NSString *const USERDEFAULT_UID_KEY = @"userDefaultUIDkey";      /**< uid 本地存储的 key*/

//Notification Setting
static NSString *const DETAIL_SWITCH_STATE = @"detailSwitchState"; /**< 消息详情开关状态*/
static NSString *const VOICE_SWITCH_STATE  = @"voiceSwitchState";  /**< 声音开关状态*/
static NSString *const SHAKE_SWITCH_STATE  = @"shakeSwitchState";  /**< 震动开关状态*/

//Stroyboard Identifier
static NSString *const IDENTIFIER_AJMEINFORMATIONVIEWCONTROLLER = @"meInformationViewController"; /**< 个人信息界面标识符*/
static NSString *const IDENTIFIER_AJTABBARVIEWCONTROLLER = @"tabbarViewController";     /**< 主页面标志符*/
static NSString *const IDENTIFIER_AJLOGINVIEWCONTROLLER = @"loginViewController";       /**< 登录界面*/

//NSNotificationCenter Key
static NSString *const NSNOTIFICATION_READMESSAGE = @"nsnotificationReadMessage";       /**< 消息界面消息已读*/
static NSString *const NSNOTIFICATION_HASUNREAD = @"nsnotificationHasUnread";           /**< 是否有未读消息*/
