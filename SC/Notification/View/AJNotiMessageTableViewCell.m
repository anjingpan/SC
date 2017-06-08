//
//  AJNotiMessageTableViewCell.m
//  SC
//
//  Created by 潘安静 on 2017/5/26.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNotiMessageTableViewCell.h"

@interface AJNotiMessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;




@end

@implementation AJNotiMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.isReaderImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter
- (void)setMessageType:(MessageType)messageType{
    _messageType = messageType;
    
    if (messageType == MessageTypeCheck) {
        self.messageLabel.type = messageTypeCheck;
    }
}

- (void)setNotification:(AJNotification *)notification{
    _notification = notification;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date;
    if (self.messageType == MessageTypeCheck) {
        date = [NSDate dateWithTimeIntervalSince1970:(int)(notification.apply_time.longLongValue)];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        date = [formatter dateFromString:notification.send_time];
        self.messageLabel.contentLabel.text = notification.content;
    }
    
    [formatter setDateFormat:@"dd"];
    self.dayLabel.text = [formatter stringFromDate:date];
    [formatter setDateFormat:@"yyyy.MM"];
    self.dateLabel.text = [formatter stringFromDate:date];
    [formatter setDateFormat:@"hh:mm"];
    self.messageLabel.time = [formatter stringFromDate:date];
    
    self.messageLabel.member = notification.user_info;
    self.messageLabel.schoolClub = notification.group_info;
    self.messageLabel.checkStatus = notification.status;
    
    if (([notification.status isEqualToString:@"0"] || [notification.is_read isEqualToString:@"0"]) && [notification.type isEqualToString:@"receive"]) {
        self.isReaderImageView.image = [UIImage imageNamed:@"Notification_Unread"];
    }else{
        self.isReaderImageView.image = [UIImage imageNamed:@"Notification_Read"];
    }
    
}

- (void)setSchedule:(AJSchedule *)schedule{
    _schedule = schedule;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [formatter dateFromString:schedule.schedule_time];
    [formatter setDateFormat:@"dd"];
    self.dayLabel.text = [formatter stringFromDate:date];
    [formatter setDateFormat:@"yyyy.MM"];
    self.dateLabel.text = [formatter stringFromDate:date];
    [formatter setDateFormat:@"hh:mm"];
    self.messageLabel.time = [formatter stringFromDate:date];
    
    //self.messageLabel.contentLabel.text = schedule.contentText;
    self.messageLabel.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:schedule.content];
    
    if (schedule.contentImageArray.count) {
        self.messageLabel.contentImageView.image = schedule.contentImageArray[0];
    }
}

@end
