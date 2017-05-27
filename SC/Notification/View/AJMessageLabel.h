//
//  AJMessageLabel.h
//  SC
//
//  Created by 潘安静 on 2017/5/26.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, messageType) {
    messageTypeNormal,  /**< 有时间标签*/
    messageTypeDetail,  /**< 无时间标签*/
};

@interface AJMessageLabel : UILabel

@property (nonatomic, assign)messageType type;

@end
