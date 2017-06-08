//
//  AJNotiMessageTableViewCell.h
//  SC
//
//  Created by 潘安静 on 2017/5/26.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJMessageLabel.h"
#import "AJNotification.h"
#import "AJSchedule.h"

typedef NS_ENUM(NSInteger, MessageType) {
    MessageTypeCheck,   /**< 审核消息*/
    MessageTypeNoti     /**< 通知消息*/
};

@interface AJNotiMessageTableViewCell : UITableViewCell

@property (nonatomic, assign)MessageType messageType;
@property (nonatomic, strong)AJNotification *notification;
@property (nonatomic, strong)AJSchedule *schedule;

@property (weak, nonatomic) IBOutlet AJMessageLabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isReaderImageView;
@end
