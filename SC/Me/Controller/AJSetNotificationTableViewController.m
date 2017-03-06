//
//  AJSetNotificationTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/3/6.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSetNotificationTableViewController.h"

@interface AJSetNotificationTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *isOpenRemindLabel;
@property (weak, nonatomic) IBOutlet UISwitch *messageDetailSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *voiceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shakeSwitch;

@end

@implementation AJSetNotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新消息通知";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
