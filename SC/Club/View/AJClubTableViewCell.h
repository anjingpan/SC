//
//  AJClubTableViewCell.h
//  SC
//
//  Created by 潘安静 on 2017/3/30.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clubTableViewCellClick)(NSInteger row);

@interface AJClubTableViewCell : UITableViewCell
@property (nonatomic, copy)clubTableViewCellClick clickBlock;

@end
