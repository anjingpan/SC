//
//  AJBaseTableViewController.h
//  SC
//
//  Created by 潘安静 on 2017/6/3.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJBaseTableViewController : UITableViewController

//是否添加下拉刷新
- (void)shouldAddPullToRefresh:(BOOL)isAdd;

//是否添加上拉加载
- (void)shouldAddPushToRefresh:(BOOL)isAdd;

- (void)reset;

//错误处理
- (void)failErrorWithView:(UIView *)view error:(NSError *)error;

@end
