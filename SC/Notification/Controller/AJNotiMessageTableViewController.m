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
#import "MKDropdownMenu.h"
#import "AJNotification+HttpRequest.h"
#import "MJRefresh.h"
#import "YYModel.h"
#import "AJProfile.h"

static NSString *const kNotiMessageTableViewCell = @"notiMessageTableViewCell";

@interface AJNotiMessageTableViewController ()<MKDropdownMenuDelegate,MKDropdownMenuDataSource>

@property (nonatomic, strong) MKDropdownMenu *dropdownMenu;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, strong) NSArray *checkNotiArray;      /**< 审核消息数组*/

@end

@implementation AJNotiMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleText;
    self.view.backgroundColor = AJBackGroundColor;
    
    self.titleArray = @[@"全部",@"收到的",@"发出的"];
    self.selectedRow = 0;
    
    [self initNavigationTitleView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self shouldAddPullToRefresh:true];
    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AJNotiMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:kNotiMessageTableViewCell];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:NSNOTIFICATION_READMESSAGE object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Load Data
- (void)loadNewData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @(self.selectedRow + 1); //1为全部的，2为收到的，3为发出的
    
    if ([self.title isEqualToString:@"通知消息"]) {
        [AJNotification getNotiListRequestWithParams:params SuccessBlock:^(id object) {
            self.checkNotiArray = [NSArray yy_modelArrayWithClass:[AJNotification class] json:object[@"data"]];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        } FailBlock:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self failErrorWithView:self.view error:error];
        }];
    }else if ([self.title isEqualToString:@"审核消息"]){
        [AJNotification getCheckRequestWithParams:params SuccessBlock:^(id object) {
            self.checkNotiArray = [NSArray yy_modelArrayWithClass:[AJNotification class] json:object[@"data"]];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        } FailBlock:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self failErrorWithView:self.view error:error];
        }];
    }
}

#pragma mark - Init View
- (void)initNavigationTitleView{
    self.dropdownMenu = ({
        MKDropdownMenu *dropdownMenu = [[MKDropdownMenu alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
        dropdownMenu.delegate = self;
        dropdownMenu.dataSource = self;
        dropdownMenu.allowsMultipleRowsSelection = false;
        self.navigationItem.titleView = dropdownMenu;
        dropdownMenu;
    });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.checkNotiArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.titleText isEqualToString:@"审核消息"]) {
        return 142.0;
    }
    return 112.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AJNotiMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNotiMessageTableViewCell];
    if (cell == nil) {
        cell = [[AJNotiMessageTableViewCell alloc] init];
    }
    
    if ([self.titleText isEqualToString:@"审核消息"]) {
        cell.messageType = MessageTypeCheck;
    }else if ([self.titleText isEqualToString:@"通知消息"]){
        cell.messageType = MessageTypeNoti;
    }
    cell.notification = self.checkNotiArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AJNotiDetailViewController *VC = [[AJNotiDetailViewController alloc] init];
    if ([self.titleText isEqualToString:@"通知消息"]) {
        VC.notification = self.checkNotiArray[indexPath.row];
        VC.detailType = messageDetailTypeNoti;
    }else if ([self.titleText isEqualToString:@"审核消息"]){
        
        //接收和拒绝的不显示详情
        if (![((AJNotification *)self.checkNotiArray[indexPath.row]).status isEqualToString:@"0"] && [((AJNotification *)self.checkNotiArray[indexPath.row]).type isEqualToString:@"post"]) {
            return;
        }
        VC.notification = self.checkNotiArray[indexPath.row];
        VC.detailType = messageDetailTypeAudit;
    }
    
    [self.navigationController pushViewController:VC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MKDropdownMenu Delegate && DataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu{
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component{
    return self.titleArray.count;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component{
    NSString *title = self.selectedRow ? self.titleArray[self.selectedRow] : self.titleText;
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:16.0],NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[NSAttributedString alloc] initWithString:self.titleArray[row] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedRow = row;
    [dropdownMenu reloadComponent:component];
    [dropdownMenu closeAllComponentsAnimated:YES];
    
    [self.tableView.mj_header beginRefreshing];
}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component{
    return AJBarColor;
}

@end
