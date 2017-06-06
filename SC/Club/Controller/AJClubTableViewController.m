//
//  AJClubTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/3/30.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJClubTableViewController.h"
#import "AJClubTableViewCell.h"
#import "AJScheduleTableViewController.h"
#import "AJAddressTableViewController.h"
#import "MKDropdownMenu.h"
#import "AJSchoolClub+Request.h"
#import "YYModel.h"

static NSString *const kClubTableViewCell = @"clubTableViewCell";

@interface AJClubTableViewController ()<MKDropdownMenuDelegate,MKDropdownMenuDataSource>

@property (nonatomic, strong) MKDropdownMenu *dropdownMenu;
@property (nonatomic, strong) NSArray *clubNameArray;           /**< 下拉选择社团名字数组*/
@property (nonatomic, strong) NSArray *clubMessageArray;        /**< 社团信息数组*/
@property (nonatomic, assign) NSInteger selectRow;

@end

@implementation AJClubTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社团";
    
    self.selectRow = 0;
    self.clubNameArray = @[@"浙江工业大学学生会",@"精弘网络"];
    
    [self loadData];
    
    [self initNavigationTitleView];
    
    [self initHeaderView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Data
- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //接口有问题，接口数据格式不应直接为数组
    [AJSchoolClub getSelfClubRequestWithParams:params SuccessBlock:^(id object) {
        self. clubMessageArray = [NSArray yy_modelArrayWithClass:[AJSchoolClub class] json:object[@"list"]];
        [self.dropdownMenu reloadAllComponents];
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
}

#pragma mark - Init
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

- (void)initHeaderView{
    
    CGFloat imageViewHeight = 160;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, imageViewHeight);
    imageView.image = [UIImage imageNamed:@"Club_Background"];
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
    
    cell.clickBlock = ^(NSInteger row){
        UIViewController *VC;
        switch (row) {
            case 0:
                //日程管理
                VC = [[AJScheduleTableViewController alloc] init];
                break;
            case 1:
                //通讯录
                VC = [[AJAddressTableViewController alloc] init];
                ((AJAddressTableViewController *)VC).groupID = ((AJSchoolClub *)self.clubMessageArray[self.selectRow]).Groupid;
                break;
            default:
                break;
        }
        
        VC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:VC animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height - 120 - 64 - 44; // 120:headerView,64:状态栏+导航栏,44：工具栏
}

#pragma mark - MKDropdownMenu Delegate && DataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu{
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component{
    
    //return self.clubMessageArray.count;
    return self.clubNameArray.count;
}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component{
    return AJBarColor;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component{
    
    //NSString *titleString = ((AJSchoolClub *)self.clubMessageArray[self.selectRow]).Groupname;
    
    return [[NSAttributedString alloc] initWithString:self.clubNameArray[self.selectRow] attributes:@{NSAttachmentAttributeName : [UIFont boldSystemFontOfSize:14.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    //NSString *titleString = ((AJSchoolClub *)self.clubMessageArray[row]).Groupname;
    return [[NSAttributedString alloc] initWithString:self.clubNameArray[row] attributes:@{NSAttachmentAttributeName : [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectRow = row;
    [dropdownMenu reloadComponent:component];
    [dropdownMenu closeAllComponentsAnimated:YES];
    
    //todo:请求
}

@end
