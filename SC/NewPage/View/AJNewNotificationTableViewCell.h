//
//  AJNewNotificationTableViewCell.h
//  SC
//
//  Created by 潘安静 on 2017/5/24.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NewNotiViewCellStyle) {
    NewNotiViewCellStyleCount,      /**< 人数*/
    NewNotiViewCellStyleSwitch,     /**< 开关*/
    NewNotiViewCellStyleTime,       /**< 时间*/
};

typedef void(^clickSwitch)(UISwitch *cellSwitch);

@interface AJNewNotificationTableViewCell : UITableViewCell

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UISwitch *cellSwitch;
@property(nonatomic, strong)UILabel *detailLbael;
@property(nonatomic, assign)NewNotiViewCellStyle style;
@property(nonatomic, copy)clickSwitch switchBlock;

@end
