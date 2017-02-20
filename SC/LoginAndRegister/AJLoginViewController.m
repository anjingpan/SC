//
//  AJLoginViewController.m
//  SC
//
//  Created by 潘安静 on 2016/12/18.
//  Copyright © 2016年 anjing. All rights reserved.
//

#import "AJLoginViewController.h"
#import "AJRegistViewController.h"

@interface AJLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userAccountTextField;  /**< 帐号输入框*/
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;     /**< 密码输入框*/
@property (weak, nonatomic) IBOutlet UIButton *loginButton;              /**< 登录按钮*/

@end

@implementation AJLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //实现圆角按钮
    self.loginButton.layer.cornerRadius = 5.f;
    self.loginButton.layer.masksToBounds = YES;
    
    self.userAccountTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    [self.userAccountTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
}

- (void)textChanged{
    self.loginButton.enabled = self.userAccountTextField.hasText && self.passwordTextField.hasText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click
- (IBAction)showPassword:(UIButton *)sender {
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
}

//登录
- (IBAction)login:(UIButton *)sender {
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userAccountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}


#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"forgetPassword"]) {
        AJRegistViewController *destinationController = (AJRegistViewController *)segue.destinationViewController;
        destinationController.numberString = self.userAccountTextField.text;
    }
}

@end
