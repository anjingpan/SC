//
//  AJNotificationTableViewCell.m
//  SC
//
//  Created by mac on 17/3/29.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNotificationTableViewCell.h"
#import "RKNotificationHub.h"

@interface AJNotificationTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *notificationMessageLabel;   /**< 未读消息标签*/
@property (strong, nonatomic) IBOutlet UILabel *notificationTimeLabel;      /**< 未读消息时间*/

@property (nonatomic, strong) RKNotificationHub *notificationHub;           /**< 未读消息标识*/
@end

@implementation AJNotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.notificationTypeImageview.frame = CGRectMake(12, 12, 74, 74);
    
    self.notificationTypeImageview.layer.cornerRadius = 10.f;
    
    self.notificationMessageLabel.text = @"暂无未读消息";
    self.notificationTimeLabel.text = @"";
    
    self.notificationHub = ({
        RKNotificationHub *hub = [[RKNotificationHub alloc] initWithView:self.notificationTypeImageview];
        [hub scaleCircleSizeBy:0.8];
        hub;
    });
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter
- (void)setMessageInfo:(AJMessageInfo *)messageInfo{
    _messageInfo = messageInfo;
    
    self.notificationMessageLabel.text = messageInfo.content;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [formatter dateFromString:messageInfo.time];
    [formatter setDateFormat:@"hh:mm"];
    self.notificationTimeLabel.text = [formatter stringFromDate:date];
}

- (void)setUnreadCount:(NSInteger)unreadCount{
    _unreadCount = unreadCount;
    self.notificationHub.count = (int)unreadCount;
}

@end
