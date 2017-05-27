//
//  AJNotificationTableViewController.m
//  SC
//
//  Created by mac on 17/3/29.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNotificationTableViewController.h"
#import "AJNotificationTableViewCell.h"
#import "AJNotiMessageTableViewController.h"

static NSString *const kNotificationTableViewCell = @"notificationTableViewCell"; /**< 重用标识*/

@interface AJNotificationTableViewController ()

@property (nonatomic, strong) NSArray *notificationTypeArray;   /**< 消息类型数组*/
@property (nonatomic, strong) NSArray *notificationIconArray;   /**< 消息对应图标数组*/
@end

@implementation AJNotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.view.backgroundColor = AJBackGroundColor;

    
    [self initData];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AJNotificationTableViewCell class]) bundle:nil] forCellReuseIdentifier:kNotificationTableViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Data
- (void)initData{
    self.notificationTypeArray = @[@"通知消息",@"审核消息",@"系统消息"];
    self.notificationIconArray = @[@"Message",@"Check",@"System"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AJNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNotificationTableViewCell];
    if (!cell) {
        cell = [[AJNotificationTableViewCell alloc] init];
    }
    cell.notificationTypeImageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"Notification_%@",self.notificationIconArray[indexPath.row]]];
    cell.notificationTypeLabel.text = self.notificationTypeArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AJNotiMessageTableViewController *VC = [[AJNotiMessageTableViewController alloc] init];
    VC.titleText = self.notificationTypeArray[indexPath.row];
    VC.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:VC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
