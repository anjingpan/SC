//
//  AJSelectMemberTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/5/25.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSelectMemberTableViewController.h"
#import "AJSelectMemberTableViewCell.h"

static NSString *const kSelectMemberTableViewCell = @"selectMemberTableViewCell";

@interface AJSelectMemberTableViewController ()
@property(nonatomic, strong) UIView *footerView;
@property(nonatomic, strong) UILabel *displayLabel;
@property(nonatomic, strong) UIButton *submitButton;

@property (nonatomic, assign) NSInteger selectCount;

@end

@implementation AJSelectMemberTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择接收人";
    self.view.backgroundColor = AJBackGroundColor;
    self.selectCount = 0;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AJSelectMemberTableViewCell class]) bundle:nil] forCellReuseIdentifier:kSelectMemberTableViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click
- (void)submit{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.selectMemberBlock) {
        self.selectMemberBlock(self.selectIndexPathArray);
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AJSelectMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectMemberTableViewCell];
    if (cell == nil) {
        cell = [[AJSelectMemberTableViewCell alloc] init];
    }
    if (self.selectIndexPathArray.count) {
        for(NSInteger i = 0 ; i < self.selectIndexPathArray.count; i ++){
            if ([self.selectIndexPathArray[i] integerValue] == indexPath.row) {
                //通过设置自定义的是否选中状态来达到选中时显示选中状态后可以去除
                cell.isSelected = !cell.isSelected;
                self.selectCount = self.selectIndexPathArray.count;
                
                [self.submitButton setTitle:[NSString stringWithFormat:@"确定(%li/16)",self.selectCount] forState:UIControlStateNormal];
                self.submitButton.enabled = true;
                self.submitButton.alpha = 1;
                
            }
        }
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 54.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //原型数据
    CGFloat footerHeight = 54.0;
    CGFloat marginX = 12.0;
    CGFloat marginY = 12.0;
    CGFloat buttonWidth = 90.0;
    CGFloat fontSize = 12.0;
    
    self.footerView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - footerHeight, [UIScreen mainScreen].bounds.size.width, footerHeight);
        view.backgroundColor = AJBackGroundColor;
        [self.view addSubview:view];
        view;
    });
    
    self.submitButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - marginX - buttonWidth, marginY, buttonWidth, footerHeight - 2 * marginY);
        button.backgroundColor = [UIColor blackColor];
        //临时解决 enable按钮不变灰
        if (!self.selectIndexPathArray.count) {
            button.enabled = false;
            button.alpha = 0.4;            
        }
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [button setTitle:[NSString stringWithFormat:@"确定(%li/16)",self.selectCount] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:button];
        button;
    });
    
    self.displayLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(marginX, marginY, [UIScreen mainScreen].bounds.size.width - buttonWidth - 3 * marginX, footerHeight - 2 * marginY);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:fontSize];
        label.text = @"已选择：";
        [self.footerView addSubview:label];
        label;
    });
    
    return self.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AJSelectMemberTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //通过设置自定义的是否选中状态来达到选中时显示选中状态后可以去除
    cell.isSelected = !cell.isSelected;
    self.selectCount = cell.isSelected ? self.selectCount + 1 : self.selectCount - 1;
    if (cell.isSelected) {
        [self.selectIndexPathArray addObject:[NSNumber numberWithInteger:indexPath.row]];
    }else{
        [self.selectIndexPathArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    
    [self.submitButton setTitle:[NSString stringWithFormat:@"确定(%li/16)",self.selectCount] forState:UIControlStateNormal];
    if (self.selectCount) {
        self.submitButton.enabled = true;
        self.submitButton.alpha = 1;
    }else{
        self.submitButton.enabled = false;
        self.submitButton.alpha = 0.4;
    }
    
    //不显示Cell选中状态
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Lazy Load
- (NSMutableArray *)selectIndexPathArray{
    if (_selectIndexPathArray == nil) {
        _selectIndexPathArray = [NSMutableArray array];
    }
    
    return _selectIndexPathArray;
}

@end
