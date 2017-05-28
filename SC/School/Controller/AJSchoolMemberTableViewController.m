//
//  AJSchoolMemberTableViewController.m
//  SC
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchoolMemberTableViewController.h"
#import "AJSchoolMemberTableViewCell.h"
#import "AJMeInformationViewController.h"
#import "AJProfile.h"

static NSString *const kSchoolMemberTableViewCell = @"schoolMemberTableViewCell";

@interface AJSchoolMemberTableViewController ()

@end

@implementation AJSchoolMemberTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成员列表";
    
    //修复可能存在标题不居中，因为返回按钮文字过长
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    NSInteger previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
    if (previousViewControllerIndex >= 0) {
        UIViewController *previousViewController = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previousViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AJSchoolMemberTableViewCell class]) bundle:nil] forCellReuseIdentifier:kSchoolMemberTableViewCell];
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
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AJSchoolMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSchoolMemberTableViewCell];
    
    if (cell == nil) {
        cell = [[AJSchoolMemberTableViewCell alloc] init];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //标志符在 storyboard中自己设置
    AJMeInformationViewController *informationViewController = [storyboard instantiateViewControllerWithIdentifier:IDENTIFIER_AJMEINFORMATIONVIEWCONTROLLER];
    informationViewController.isAllowEdit = false;
    [self.navigationController pushViewController:informationViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
