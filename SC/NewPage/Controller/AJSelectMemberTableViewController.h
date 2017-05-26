//
//  AJSelectMemberTableViewController.h
//  SC
//
//  Created by 潘安静 on 2017/5/25.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectMemberClick)(NSMutableArray *array);

@interface AJSelectMemberTableViewController : UITableViewController

@property (nonatomic, copy)selectMemberClick selectMemberBlock;
@property (nonatomic, strong)NSMutableArray *selectIndexPathArray;
@end
