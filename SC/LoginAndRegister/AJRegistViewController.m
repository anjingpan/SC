//
//  AJRegistViewController.m
//  SC
//
//  Created by 潘安静 on 2016/12/21.
//  Copyright © 2016年 anjing. All rights reserved.
//

#import "AJRegistViewController.h"

@interface AJRegistViewController ()
@property (assign, nonatomic) BOOL isCoundDown;                         /**< 是否正在倒计时*/
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;       /**< 手机号码输入框*/
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;  /**< 验证码输入框*/
@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeButton;     /**< 获取验证码按钮*/
@property (weak, nonatomic) IBOutlet UIButton *nextButton;              /**< 下一步按钮*/

@end

@implementation AJRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isCoundDown = NO;
    if (self.numberString) {
        self.phoneTextField.text = self.numberString;
        self.getVerifyCodeButton.enabled = YES;
    }
    
    self.getVerifyCodeButton.layer.cornerRadius = 3.f;
    self.getVerifyCodeButton.layer.masksToBounds = YES;
    self.nextButton.layer.cornerRadius = 5.f;
    self.nextButton.layer.masksToBounds = YES;
    
    [self.phoneTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    [self.verifyCodeTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
}

- (void)textChanged{
    //在倒计时时无法将其状态修改
//    if ([self.getVerifyCodeButton.titleLabel.text isEqualToString:@"获取验证码"]) {
//        self.getVerifyCodeButton.enabled = self.phoneTextField.hasText;
//    }
    if (!self.isCoundDown) {
        self.getVerifyCodeButton.enabled = self.phoneTextField.hasText;
    }
    self.nextButton.enabled = self.phoneTextField.hasText && self.verifyCodeTextField.hasText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getVrifyCode:(UIButton *)sender {
    [self.phoneTextField resignFirstResponder];
    [self openCoundDown];
}

- (void)openCoundDown{
    
    __block NSInteger time = 60;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        time -- ;
        
        if (time <= 0) {
            dispatch_source_cancel(timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.getVerifyCodeButton.enabled = YES;
                [weakSelf.getVerifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                weakSelf.isCoundDown = NO;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.getVerifyCodeButton.enabled = NO;
                [weakSelf.getVerifyCodeButton setTitle:[NSString stringWithFormat:@"已发送%ldS",time] forState:UIControlStateNormal];
                weakSelf.isCoundDown = YES;
            });
        }
    });
    dispatch_resume(timer);
}

- (IBAction)finishToNext:(UIButton *)sender {
    [self.phoneTextField resignFirstResponder];
    [self.verifyCodeTextField resignFirstResponder];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneTextField resignFirstResponder];
    [self.verifyCodeTextField resignFirstResponder];
}

@end
