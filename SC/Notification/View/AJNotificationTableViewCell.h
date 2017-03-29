//
//  AJNotificationTableViewCell.h
//  SC
//
//  Created by mac on 17/3/29.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJNotificationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *notificationTypeImageview;  /**< 消息类型图片视图*/
@property (strong, nonatomic) IBOutlet UILabel *notificationTypeLabel;          /**< 消息类型标签*/

@end
