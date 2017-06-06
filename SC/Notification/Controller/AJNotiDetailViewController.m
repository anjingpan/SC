//
//  AJNotiDetailViewController.m
//  SC
//
//  Created by 潘安静 on 2017/5/27.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNotiDetailViewController.h"
#import "AJMessageLabel.h"
#import "AJNotiCheckViewController.h"

@interface AJNotiDetailViewController ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) AJMessageLabel *messageDetailLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *refruseButton;              /**< 审核消息中拒绝加入按钮*/
@property (nonatomic, strong) UIButton *checkButton;                /**< 查看确认传达按钮*/

@end

@implementation AJNotiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"消息详情";
    self.view.backgroundColor = AJBackGroundColor;
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init View
- (void)initView{
    
    CGFloat marginX = 12.0;
    CGFloat marginY = 12.0;
    CGFloat timeLabelHeight = 14.0;
    CGFloat messageHeight = 120.0;
    CGFloat buttonHeight = 44.0;
    CGFloat fontSize = 12.0;
    CGFloat buttonFontSize = 18.0;
    
    self.timeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, marginY + 64.0, [UIScreen mainScreen].bounds.size.width, timeLabelHeight);
        label.font = [UIFont systemFontOfSize:fontSize];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"2017年5月27日 01:42";
        [self.view addSubview:label];
        label;
    });
    
    self.messageDetailLabel = ({
        AJMessageLabel *messageLabel = [[AJMessageLabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(self.timeLabel.frame) + marginY, [UIScreen mainScreen].bounds.size.width - 2 * marginX, messageHeight)];
        messageLabel.type = messageTypeDetail;
        [self.view addSubview:messageLabel];
        messageLabel;
    });
    
    self.checkButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(marginX, CGRectGetMaxY(self.messageDetailLabel.frame) + 1, [UIScreen mainScreen].bounds.size.width - 2 * marginX, buttonHeight);
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize - 4];
        [button setTitle:@"点击查看确认详情" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(checkConfirm) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self. confirmButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(marginX, [UIScreen mainScreen].bounds.size.height - buttonHeight - marginY, [UIScreen mainScreen].bounds.size.width - 2 * marginX, buttonHeight);
        button.layer.cornerRadius = 5.0;
        button.layer.masksToBounds = true;
        button.backgroundColor = [UIColor blackColor];
        button.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
        [button setTitle:@"确认传达" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(confirmDeliver) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    if (self.detailType == messageDetailTypeNoti) {
        self.checkButton.hidden = false;
        [self.confirmButton setTitle:@"确认传达" forState:UIControlStateNormal];
    }else if (self.detailType == messageDetailTypeAudit){
        self.checkButton.hidden = true;
        [self.confirmButton setTitle:@"同意" forState:UIControlStateNormal];
        
        self.refruseButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(marginX, [UIScreen mainScreen].bounds.size.height - buttonHeight - marginY, ([UIScreen mainScreen].bounds.size.width - 3 * marginX) * 0.5, buttonHeight);
            button.layer.cornerRadius = 5.0;
            button.layer.masksToBounds = true;
            button.backgroundColor = [UIColor blackColor];
            button.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
            [button setTitle:@"拒绝" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(refuse) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            button;
        });
        self.confirmButton.frame = CGRectMake(CGRectGetMaxX(self.refruseButton.frame) + marginX,[UIScreen mainScreen].bounds.size.height - buttonHeight - marginY, ([UIScreen mainScreen].bounds.size.width - 3 * marginX) * 0.5, buttonHeight);
    }
    
}

#pragma mark - Button Click

- (void)checkConfirm{
    AJNotiCheckViewController *VC = [[AJNotiCheckViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)confirmDeliver{
    
}

- (void)refuse{
    
}

@end
