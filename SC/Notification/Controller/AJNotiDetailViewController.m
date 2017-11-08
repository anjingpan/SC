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
#import "AJNotification+HttpRequest.h"
#import "MBProgressHUD.h"
#import "YYModel.h"
#import "AJProfile.h"

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
        //适配 iPhone X
        label.frame = CGRectMake(0, marginY + kMarginTop, [UIScreen mainScreen].bounds.size.width, timeLabelHeight);
        label.font = [UIFont systemFontOfSize:fontSize];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy年MM月dd日 hh:mm"];
        label.text = [format stringFromDate:[NSDate dateWithTimeIntervalSince1970:(int)self.notification.apply_time.longLongValue]];
        [self.view addSubview:label];
        label;
    });
    
    self.messageDetailLabel = ({
        AJMessageLabel *messageLabel = [[AJMessageLabel alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(self.timeLabel.frame) + marginY, [UIScreen mainScreen].bounds.size.width - 2 * marginX, messageHeight)];
        messageLabel.type = messageTypeDetail;
        messageLabel.member = self.notification.user_info;
        messageLabel.schoolClub = self.notification.group_info;
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
        //适配iPhone X
        button.frame = CGRectMake(marginX, [UIScreen mainScreen].bounds.size.height - buttonHeight - marginY - kMarginBottom, [UIScreen mainScreen].bounds.size.width - 2 * marginX, buttonHeight);
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
    
    if (self.detailType == messageDetailTypeNoti) {
        self.messageDetailLabel.contentLabel.text = self.notification.content;
        self.timeLabel.text = self.notification.send_time;
    }else{
        self.messageDetailLabel.contentLabel.text = @"申请加入该社团";
    }
    
    //如果是自己则没有按钮显示
    if (self.notification.user_info.uid == [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_UID_KEY]) {
        self.confirmButton.hidden = YES;
        self.refruseButton.hidden = YES;
    }
}

#pragma mark - Button Click

- (void)checkConfirm{
    AJNotiCheckViewController *VC = [[AJNotiCheckViewController alloc] init];
    VC.textID = self.notification.text_id;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)confirmDeliver{
    if (self.detailType == messageDetailTypeNoti) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"msg_id"] = self.notification.msg_id;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在提交数据";
        [AJNotification readNotiRequestWithParams:params SuccessBlock:^(id object) {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"提交成功";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:true];
                [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_READMESSAGE object:nil];
                [self.navigationController popViewControllerAnimated:true];
            });
        } FailBlock:^(NSError *error) {
            [self failErrorWithView:self.view error:error];
        }];
    }else{
        [self handleCheckNotiWithStatus:@"1"];
    }
}

- (void)refuse{
    [self handleCheckNotiWithStatus:@"0"];
}

#pragma mark - Http Request
- (void)handleCheckNotiWithStatus:(NSString *)status{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"groupid"] = self.notification.group_info.Groupid;
    params[@"uid"] = self.notification.user_info.uid;
    params[@"handle"] = status;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.label.text = @"正在提交数据";
    
    [AJNotification handleCheckRequestWithParams:params SuccessBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"提交成功";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:true];
            [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_READMESSAGE object:nil];
            [self.navigationController popViewControllerAnimated:true];
        });
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
    
}


@end
