//
//  AJAddressTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/6/3.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJAddressTableViewController.h"
#import "AJMember+Request.h"
#import "MJRefresh.h"
#import "YYModel.h"
#import "UIImageView+RoundRect.h"

static NSString *const kAddressTableViewCell = @"addressTableViewCell";

@interface AJAddressTableViewController ()

@property (nonatomic, strong) NSArray *memberArray;

@end

@implementation AJAddressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    self.view.backgroundColor = AJBackGroundColor;
    
    [self shouldAddPullToRefresh:true];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Data
- (void)loadNewData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"groupid"] = self.groupID;
    
    [AJMember getContactsRequestWithParams:params SuccessBlock:^(id object) {
        self.memberArray = [NSArray yy_modelArrayWithClass:[AJMember class] json:object[@"data"]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.memberArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressTableViewCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kAddressTableViewCell];
    }
    
    AJMember *member = self.memberArray[indexPath.row];
    
    //暂时修复获取不到 cell 中 imageView 的 frame 问题
    [cell.imageView setRoundImageUrlStr:member.imgurl placeholder:nil WithCornerRadius:32.0 completed:nil];
    cell.textLabel.text = member.RealName;
    cell.detailTextLabel.text = member.username;
    cell.detailTextLabel.textColor = [UIColor blueColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",cell.detailTextLabel.text]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:cell.detailTextLabel.text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
