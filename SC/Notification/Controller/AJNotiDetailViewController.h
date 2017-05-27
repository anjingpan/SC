//
//  AJNotiDetailViewController.h
//  SC
//
//  Created by 潘安静 on 2017/5/27.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, messageDetailType) {
    messageDetailTypeNoti,      /**< 通知消息*/
    messageDetailTypeAudit,     /**< 审核消息*/
};

@interface AJNotiDetailViewController : UIViewController

@property (nonatomic, assign)messageDetailType detailType;

@end
