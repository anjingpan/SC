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
#import "AJMessageUnread+HttpRequest.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "AJProfile.h"

static NSString *const kNotificationTableViewCell = @"notificationTableViewCell"; /**< 重用标识*/

@interface AJNotificationTableViewController ()

@property (nonatomic, strong) NSArray *notificationTypeArray;   /**< 消息类型数组*/
@property (nonatomic, strong) NSArray *notificationIconArray;   /**< 消息对应图标数组*/

@property (nonatomic, strong) AJMessageUnread *unreadInfo;
@end

@implementation AJNotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.view.backgroundColor = AJBackGroundColor;

    
    [self initData];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AJNotificationTableViewCell class]) bundle:nil] forCellReuseIdentifier:kNotificationTableViewCell];
    
    [self shouldAddPullToRefresh:true];
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:NSNOTIFICATION_READMESSAGE object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Load Data
- (void)loadNewData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [AJMessageUnread getUnreadCountRequestWithParams:params SuccessBlock:^(id object) {
        self.unreadInfo = [AJMessageUnread yy_modelWithJSON:object[@"data"]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        if (![self.unreadInfo.system_msg integerValue] || ![self.unreadInfo.apply_count integerValue] || ![self.unreadInfo.msg_count integerValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_HASUNREAD object:@{@"hasUnread":@"1"}];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_HASUNREAD object:@{@"hasUnread" : @"0"}];
        }
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
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
    switch (indexPath.row) {
        case 0:
            cell.unreadCount = [self.unreadInfo.msg_count integerValue];
            if (cell.unreadCount) {
                cell.messageInfo = self.unreadInfo.msg_info;
            }
            break;
        case 1:
            cell.unreadCount = [self.unreadInfo.apply_count integerValue];
            if (cell.unreadCount) {
                cell.messageInfo = self.unreadInfo.apply_info;
            }
            break;
        case 2:
            cell.unreadCount = [self.unreadInfo.system_msg integerValue];
            if (cell.unreadCount) {
                cell.messageInfo = self.unreadInfo.systme_info;
            }
            break;
        default:
            break;
    }
    
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
