//
//  AJNotiMessageTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/5/26.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNotiMessageTableViewController.h"
#import "AJNotiMessageTableViewCell.h"
#import "AJNotiDetailViewController.h"

static NSString *const kNotiMessageTableViewCell = @"notiMessageTableViewCell";

@interface AJNotiMessageTableViewController ()

@end

@implementation AJNotiMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    self.view.backgroundColor = AJBackGroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AJNotiMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:kNotiMessageTableViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AJNotiMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNotiMessageTableViewCell];
    if (cell == nil) {
        cell = [[AJNotiMessageTableViewCell alloc] init];
    }
    if (indexPath.row <= 3) {
        cell.isReaderImageView.image = [UIImage imageNamed:@"Notification_Unread"];
    }else{
        cell.isReaderImageView.image = [UIImage imageNamed:@"Notification_Read"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AJNotiDetailViewController *VC = [[AJNotiDetailViewController alloc] init];
    if ([self.titleText isEqualToString:@"通知消息"]) {
        VC.detailType = messageDetailTypeNoti;
    }else if ([self.titleText isEqualToString:@"审核消息"]){
        VC.detailType = messageDetailTypeAudit;
    }
    [self.navigationController pushViewController:VC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
