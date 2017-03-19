//
//  AJSetNotificationTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/3/6.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSetNotificationTableViewController.h"
#import "AJProfile.h"

@interface AJSetNotificationTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *isOpenRemindLabel;    /**< 是否接收新消息通知*/
@property (weak, nonatomic) IBOutlet UISwitch *messageDetailSwitch; /**< 显示消息详情开关*/
@property (weak, nonatomic) IBOutlet UISwitch *voiceSwitch;         /**< 声音开关*/
@property (weak, nonatomic) IBOutlet UISwitch *shakeSwitch;         /**< 震动开关*/

@end

@implementation AJSetNotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新消息通知";
    [self setSwitchState];
    [self.messageDetailSwitch addTarget:self action:@selector(messageDetailSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.voiceSwitch addTarget:self action:@selector(voiceSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.shakeSwitch addTarget:self action:@selector(shakeSwitchChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSwitchState{
    NSString *isMessageDetail = [[NSUserDefaults standardUserDefaults] objectForKey:DETAIL_SWITCH_STATE];
    if (!isMessageDetail || [isMessageDetail isEqualToString:@"1"]) {
        [self.messageDetailSwitch setOn:YES animated:YES];
    }else{
        [self.messageDetailSwitch setOn:NO animated:YES];
    }
    
    NSString *isVoice = [[NSUserDefaults standardUserDefaults] objectForKey:VOICE_SWITCH_STATE];
    //默认为开启
    if (!isVoice || [isVoice isEqualToString:@"1"]) {
        [self.voiceSwitch setOn:YES animated:YES];
    }else{
        [self.voiceSwitch setOn:NO animated:YES];
    }
    
    NSString *isShake = [[NSUserDefaults standardUserDefaults] objectForKey:SHAKE_SWITCH_STATE];
    if (!isShake || [isShake isEqualToString:@"1"]) {
        [self.shakeSwitch setOn:YES animated:YES];
    }else{
        [self.shakeSwitch setOn:NO animated:YES];
    }
    
    if ([self isAllowNotification]) {
        self.isOpenRemindLabel.text = @"已开启";
    }else{
        self.isOpenRemindLabel.text = @"已关闭";
    }
}

#pragma mark - switch changed
- (void)messageDetailSwitchChanged:(UISwitch *)sender{
    [[NSUserDefaults standardUserDefaults] setObject:self.messageDetailSwitch.on ? @"1" :@"0" forKey:DETAIL_SWITCH_STATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)voiceSwitchChanged:(UISwitch *)sender{
    [[NSUserDefaults standardUserDefaults] setObject:self.voiceSwitch.on ? @"1":@"0" forKey:VOICE_SWITCH_STATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)shakeSwitchChanged:(UISwitch *)sender{
    [[NSUserDefaults standardUserDefaults] setObject:self.shakeSwitch.on ? @"1":@"0" forKey:SHAKE_SWITCH_STATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Notification setting
- (BOOL)isAllowNotification{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone != setting.types) {
        return YES;
    }
    return NO;
}

@end
