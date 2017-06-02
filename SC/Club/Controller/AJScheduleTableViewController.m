//
//  AJScheduleTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/6/2.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJScheduleTableViewController.h"
#import "AJNotiMessageTableViewCell.h"
#import "AJScheduleDetailViewController.h"

static NSString *const kScheduleTableViewCell = @"scheduleTableViewCell";

@interface AJScheduleTableViewController ()

@end

@implementation AJScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日程管理";
    self.view.backgroundColor = AJBackGroundColor;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AJNotiMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:kScheduleTableViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AJNotiMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScheduleTableViewCell];
    if (cell == nil) {
        cell = [[AJNotiMessageTableViewCell alloc] init];
    }
    
    if (indexPath.row > 2) {
        cell.messageLabel.type = messageTypeSchedule;
    }else{
        cell.messageLabel.type = messageTypeWithImage;
    }
    cell.isReaderImageView.image = [UIImage imageNamed:@"Notification_Read"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AJScheduleDetailViewController *VC = [[AJScheduleDetailViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
