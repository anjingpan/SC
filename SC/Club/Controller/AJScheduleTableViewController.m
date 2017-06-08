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
#import "AJSchedule+HttpRequest.h"
#import "MJRefresh.h"
#import "YYModel.h"

static NSString *const kScheduleTableViewCell = @"scheduleTableViewCell";

@interface AJScheduleTableViewController ()
@property (nonatomic, strong) NSArray *scheduleArray;

@end

@implementation AJScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日程管理";
    self.view.backgroundColor = AJBackGroundColor;
    
    [self shouldAddPullToRefresh:true];
    [self.tableView.mj_header beginRefreshing];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AJNotiMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:kScheduleTableViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Data
- (void)loadNewData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"group_id"] = self.groupID;
    
    [AJSchedule getScheduleRequestWithParams:params SuccessBlock:^(id object) {
        self.scheduleArray = [NSArray yy_modelArrayWithClass:[AJSchedule class] json:object[@"data"]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
}

#pragma mark - AttributeText
- (NSString *)attributeTextToText:(NSString *)string{
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:string];
    NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc] initWithAttributedString:attributeString];
    [attributeString enumerateAttributesInRange:NSMakeRange(0, attributeString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSTextAttachment *textAttach = attrs[@"NSTextAttachment"];
        
        //图片处用空格代替
        if (textAttach) {
            [resultText replaceCharactersInRange:range withString:@""];
        }
    }];
    
    return resultText.string;
}

//无法获取到图片
- (NSArray *)attributeTextToImageArray:(NSString *)string{
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:string];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    [attributeString enumerateAttributesInRange:NSMakeRange(0, attributeString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSTextAttachment *textAttach = attrs[@"NSTextAttachment"];
        
        if (textAttach) {
            [resultArray addObject:textAttach.image];
        }
    }];
    
    return resultArray;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scheduleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AJNotiMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScheduleTableViewCell];
    if (cell == nil) {
        cell = [[AJNotiMessageTableViewCell alloc] init];
    }
    
    cell.isReaderImageView.image = [UIImage imageNamed:@"Notification_Read"];
    
    ((AJSchedule *)self.scheduleArray[indexPath.row]).contentText =  [self attributeTextToText:((AJSchedule *)self.scheduleArray[indexPath.row]).content];
    ((AJSchedule *)self.scheduleArray[indexPath.row]).contentImageArray = [self attributeTextToImageArray:((AJSchedule *)self.scheduleArray[indexPath.row]).content];
    
    if (((AJSchedule *)self.scheduleArray[indexPath.row]).contentImageArray.count) {
        cell.messageLabel.type = messageTypeWithImage;
    }else{
        cell.messageLabel.type = messageTypeSchedule;
    }
    
    cell.schedule = self.scheduleArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AJScheduleDetailViewController *VC = [[AJScheduleDetailViewController alloc] init];
    VC.schedule = self.scheduleArray[indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
