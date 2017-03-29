//
//  AJClubTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/3/30.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJClubTableViewController.h"
#import "AJClubTableViewCell.h"

static NSString *const kClubTableViewCell = @"clubTableViewCell";

@interface AJClubTableViewController ()

@end

@implementation AJClubTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社团";
    
    [self initHeaderView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init
- (void)initHeaderView{
    
    CGFloat imageViewHeight = 120;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, imageViewHeight);
    imageView.image = [UIImage imageNamed:@""];
    self.tableView.tableHeaderView = imageView;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AJClubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kClubTableViewCell];
    if (!cell) {
        cell = [[AJClubTableViewCell alloc] init];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height - 120 - 64 - 44; // 120:headerView,64:状态栏+导航栏,44：工具栏
}

@end
