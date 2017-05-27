//
//  AJNotiMessageTableViewCell.h
//  SC
//
//  Created by 潘安静 on 2017/5/26.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJMessageLabel.h"

@interface AJNotiMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isReaderImageView;
@property (weak, nonatomic) IBOutlet AJMessageLabel *messageLabel;

@end
