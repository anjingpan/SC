//
//  AJNewNotificationViewController.m
//  SC
//
//  Created by 潘安静 on 2017/5/22.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNewNotificationViewController.h"
#import "AJFormTextView.h"
#import "AJNewNotificationTableViewCell.h"
#import "AJSelectMemberTableViewController.h"
#import "AJSchoolClub+Request.h"
#import "AJMember+Request.h"
#import "MBProgressHUD.h"
#import "YYModel.h"
#import "AJNotification+HttpRequest.h"

static NSString *const kNewNotiTableViewCell = @"newNotiTableViewCell";

@interface AJNewNotificationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) AJFormTextView *notificationTextView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *footerView;
@property(nonatomic, strong) UIButton *senderButton;
@property(nonatomic, strong) UIToolbar *toolbar;
@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, assign) NSInteger rowNumber;
@property(nonatomic, strong) NSDate *timingDate;
@property(nonatomic, strong) NSMutableArray *selectMemberArray;     /**< 选择成员的编号数组*/
@property(nonatomic, strong) NSNumber *selectClubRow;               /**< 选择社团的编号*/ //为了可判断为 nil
@property(nonatomic, strong) NSArray *clubArray;                    /**< 请求得到社团数组*/
@property(nonatomic, strong) NSArray *memberArray;                  /**< 请求得到成员数组*/

@end

@implementation AJNewNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新建通知";
    self.view.backgroundColor = AJBackGroundColor;
    self.rowNumber = 3;
    //有多个 scrollView 时设置，防止第一个 contentOffset有偏移（UITextView,TableView）
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init View
- (void)initView{
    
    //原型数据
    CGFloat headerViewHeight = 120.0;
    CGFloat marginY = 20.0;
    CGFloat marginX = 20.0;
    
    self.headerView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 64 + marginY, [UIScreen mainScreen].bounds.size.width, headerViewHeight);
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        view;
    });
    
    self.notificationTextView = ({
        AJFormTextView *textView = [[AJFormTextView alloc] initWithFrame:CGRectMake(marginX, marginY, self.headerView.frame.size.width - 2 * marginX, headerViewHeight - marginY - 1)];
        textView.placeholderText = @"通知消息内容";
        [self.headerView addSubview:textView];
        textView;
    });
    
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame) + marginY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.notificationTextView.frame))];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
}

#pragma mark - Load Data
- (void)loadClubWithViewController:(AJSelectMemberTableViewController *)VC{
    VC.selectType = selectTypeClub;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.label.text = @"正在加载社团";
    [AJSchoolClub getSelfClubRequestWithParams:params SuccessBlock:^(id object) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        
        self.clubArray = [NSArray yy_modelArrayWithClass:[AJSchoolClub class] json:object[@"data"]];
        VC.dataArray = self.clubArray;
        [self.navigationController pushViewController:VC animated:true];
        
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
}

- (void)loadMemberWithViewController:(AJSelectMemberTableViewController *)VC{
    VC.selectType = selectTypeMember;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    if (self.selectClubRow == nil) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请先选择社团";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:true];
        });
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"groupid"] = ((AJSchoolClub *)self.clubArray[[self.selectClubRow integerValue]]).Groupid;
    
    hud.label.text = @"正在加载成员";
    [AJMember getContactsRequestWithParams:params SuccessBlock:^(id object) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        
        self.memberArray = [NSArray yy_modelArrayWithClass:[AJMember class] json:object[@"data"]];
        VC.dataArray = self.memberArray;
        [self.navigationController pushViewController:VC animated:true];
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
}

#pragma mark - Click
- (void)senderNotification{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.label.text = @"正在提交数据";
    //没选择好数据不能提交
    if (self.selectMemberArray.count == 0 || self.selectClubRow == nil) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请选择通知的社团和成员";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:true];
        });
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    params[@"send_time"] = self.datePicker.date ? [formatter stringFromDate:self.datePicker.date] : [formatter stringFromDate: [NSDate date]];
    NSString *msg_to = @"";
    for (int i = 0; i < self.selectMemberArray.count; i ++) {
        NSInteger indexpathRow = [self.selectMemberArray[i] integerValue];
        NSLog(@"%@",[NSString stringWithFormat:@"%@,", ((AJMember *)self.memberArray[indexpathRow]).uid]);
        NSLog(@"%@",self.memberArray[indexpathRow]);
        msg_to = [msg_to stringByAppendingString:[NSString stringWithFormat:@"%@,", ((AJMember *)self.memberArray[indexpathRow]).uid]];
    }
    
    params[@"msg_to"] = msg_to;
    params[@"group_id"] = ((AJSchoolClub *)self.clubArray[[self.selectClubRow integerValue]]).Groupid;
    params[@"content"] = self.notificationTextView.text;
    
    [AJNotification sendNotiRequestWithParams:params SuccessBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"提交成功";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:true];
        });
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
    
}

- (void)showDatePicker:(NSDate *)date {
    //原型数据
    CGFloat toolbarHeight = 40.0;
    CGFloat datePickerHeight = 210.0;
    
    if (self.toolbar == nil && self.datePicker == nil) {
        
        
        self.datePicker = ({
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - datePickerHeight, [UIScreen mainScreen].bounds.size.width, datePickerHeight)];
            datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            [datePicker setDate:date];
            [self.view addSubview:datePicker];
            datePicker;
        });
        
        self.toolbar = ({
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.datePicker.frame) - toolbarHeight, [UIScreen mainScreen].bounds.size.width, toolbarHeight)];
            toolbar.barStyle = UIBarStyleBlack;
            toolbar.backgroundColor = AJBarColor;
            toolbar.tintColor = [UIColor whiteColor];
            
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPickDate)];
            UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(confirmPickDate)];
            NSArray *barButtonArray = [NSArray arrayWithObjects:cancelButton,flexibleButton,doneButton, nil];
            [toolbar setItems:barButtonArray];
            [self.view addSubview:toolbar];
            toolbar;
        });
    }else{
        self.datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - datePickerHeight, [UIScreen mainScreen].bounds.size.width, datePickerHeight);
        self.toolbar.frame = CGRectMake(0, CGRectGetMinY(self.datePicker.frame) - toolbarHeight, [UIScreen mainScreen].bounds.size.width, toolbarHeight);
    }
}

#pragma mark - Date Picker
- (void)cancelPickDate{
    self.datePicker.frame = CGRectZero;
    self.toolbar.frame = CGRectZero;
}

- (void)confirmPickDate{
    self.datePicker.frame = CGRectZero;
    self.toolbar.frame = CGRectZero;
    self.timingDate = self.datePicker.date;
    [self.tableView reloadData];
}

#pragma mark - TableView Delegate && DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rowNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AJNewNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewNotiTableViewCell];
    
    if (cell == nil) {
        cell = [[AJNewNotificationTableViewCell alloc] init];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.style = NewNotiViewCellStyleCount;
            cell.titleLabel.text = @"接收社团";
            if (self.selectClubRow != nil && self.clubArray.count >= self.selectClubRow.integerValue) {
                cell.detailLbael.text = ((AJSchoolClub *)self.clubArray[self.selectClubRow.integerValue]).Groupname;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
        case 1:
            cell.style = NewNotiViewCellStyleCount;
            cell.titleLabel.text = @"接收人";
            cell.detailLbael.text = self.selectMemberArray.count ? [NSString stringWithFormat:@"%li人",self.selectMemberArray.count] : @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
        case 2:
            cell.style = NewNotiViewCellStyleSwitch;
            cell.titleLabel.text = @"定时发送";
            if (self.rowNumber == 4) {
                cell.cellSwitch.on = true;
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 3:
            cell.style = NewNotiViewCellStyleTime;
            cell.titleLabel.text = @"发送时间";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
            if (self.timingDate != nil) {
                cell.detailLbael.text = [dateFormatter stringFromDate:self.timingDate];
            }else{
                NSDate *date = [NSDate date];
                cell.detailLbael.text = [dateFormatter stringFromDate:date];
            }
            break;
    }
    
    if (indexPath.row == 2) {
        //通过 block 传递 switch 状态切换事件
        cell.switchBlock = ^(UISwitch *cellSwitch){
            //收起键盘
            [self.notificationTextView resignFirstResponder];
            self.rowNumber = cellSwitch.on? 4:3;
            [self.tableView reloadData];
        };
    }
    return cell;
}

//要显示 footerView 一定要写，但是其高度会根据设置 View 时的高度来显示
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 64.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    //原型数据
    CGFloat footerHeight = 64.0;
    CGFloat marginX = 12.0;
    CGFloat marginY = 10.0;
    CGFloat buttonFontSize = 18.0;
    
    self.footerView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, footerHeight);
        view;
    });
    
    self.senderButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(marginX, marginY, self.footerView.frame.size.width - 2 * marginX, footerHeight - 2 * marginY);
        button.backgroundColor = AJBarColor;
        button.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
        [button setTitle:@"发送通知" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(senderNotification) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:button];
        button;
    });
    
    return self.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //收起键盘
    [self.notificationTextView resignFirstResponder];
    
    if (indexPath.row == 0) {
        AJSelectMemberTableViewController *VC = [[AJSelectMemberTableViewController alloc] init];
        VC.selectMemberBlock = ^(NSMutableArray *array){
            
            AJNewNotificationTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailLbael.text = ((AJSchoolClub *)self.clubArray[[array[0] integerValue]]).Groupname;
            self.selectClubRow = array[0];
        };
        
        //如果有选中的值，将其传给下一页面
        if (self.selectClubRow != nil) {
            VC.selectIndexPathArray = [NSMutableArray arrayWithObject:self.selectClubRow];
        }
        [self loadClubWithViewController:VC];
    }else if (indexPath.row == 1) {
        
        AJSelectMemberTableViewController *VC = [[AJSelectMemberTableViewController alloc] init];
        VC.selectMemberBlock = ^(NSMutableArray *array){
            
            AJNewNotificationTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailLbael.text = [NSString stringWithFormat:@"%li人",array.count];
            self.selectMemberArray = array;
        };
        
        //如果有选中的值，将其传给下一页面
        if (self.selectMemberArray.count) {
            VC.selectIndexPathArray = self.selectMemberArray;
        }
        [self loadMemberWithViewController:VC];
        
    }else if (indexPath.row == 3){
        AJNewNotificationTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSDate *date = [dateFormatter dateFromString:cell.detailLbael.text];
        [self showDatePicker:date];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Lazy Load
- (NSMutableArray *)selectMemberArray{
    if (_selectMemberArray == nil) {
        _selectMemberArray = [NSMutableArray array];
    }
    
    return _selectMemberArray;
}

@end
