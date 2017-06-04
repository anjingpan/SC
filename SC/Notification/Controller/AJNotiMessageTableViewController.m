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

static NSString *const kNotiMessageTableViewCell = @"notiMessageTableViewCell";

@interface AJNotiMessageTableViewController ()<MKDropdownMenuDelegate,MKDropdownMenuDataSource>

@property (nonatomic, strong) MKDropdownMenu *dropdownMenu;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) NSInteger selectedRow;

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
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AJNotiMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:kNotiMessageTableViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //todo:请求
}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component{
    return AJBarColor;
}

@end
