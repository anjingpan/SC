//
//  AJPasswordViewController.m
//  SC
//
//  Created by 潘安静 on 2017/2/20.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJPasswordViewController.h"
#import "AJPasswordTextField.h"

@interface AJPasswordViewController ()

@property (nonatomic, strong) AJPasswordTextField *passwordTextField;           /**< 密码输入框*/
@property (nonatomic, strong) UIView *firstLineView;                    /**< 分割线*/
@property (nonatomic, strong) AJPasswordTextField *confirmPasswordTextField;    /**< 确认密码输入框*/
@property (nonatomic, strong) UIView *secondLineView;                   /**< 分割线*/
@property (nonatomic, strong) UIButton *enterButton;                    /**< 确认进入按钮*/
@end

@implementation AJPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = AJBackGroundColor;
    self.title = @"输入密码";
    
    [self initView];
}

- (void)initView{
    
    //原型数值
    CGFloat marginX     = 16.0f;                  /**< 左右间距*/
    CGFloat marginTop   = 12.0f;                  /**< 距离最上面间距*/
    CGFloat marginY     = 8.0f;                   /**< 控件上下间距*/
    CGFloat font        = 16.0f;                  /**< 字体大小*/
    CGFloat height      = 30.0f;                  /**< 控件高度*/
    CGFloat buttonHeight= 40.0f;                  /**< 按钮高度*/
    CGFloat buttonFont  = 18.0f;                  /**< 按钮字体*/
    
    self.passwordTextField = ({
        AJPasswordTextField *textField = [[AJPasswordTextField alloc] init];
        textField.frame = CGRectMake(marginX, 20 +44 + marginTop, [UIScreen mainScreen].bounds.size.width - 2 * marginX, height);
        textField.font = [UIFont systemFontOfSize:font];
        textField.placeholder = @"请输入密码";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.secureTextEntry = YES;
        [textField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:textField];
        textField;
    });
    
    self.firstLineView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(marginX, CGRectGetMaxY(self.passwordTextField.frame) +marginY, [UIScreen mainScreen].bounds.size.width - 2 * marginX, 1);
        view.backgroundColor = AJBlackColor(0.3f);
        [self.view addSubview:view];
        view;
    });
    
    self.confirmPasswordTextField = ({
        AJPasswordTextField *textField = [[AJPasswordTextField alloc] init];
        textField.frame = CGRectMake(marginX, CGRectGetMaxY(self.firstLineView.frame) + marginY, [UIScreen mainScreen].bounds.size.width - 2 * marginX, height);
        textField.font = [UIFont systemFontOfSize:font];
        textField.placeholder = @"请确认密码";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.secureTextEntry = YES;
        [textField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:textField];
        textField;
    });
    
    self.secondLineView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(marginX, CGRectGetMaxY(self.confirmPasswordTextField.frame) +marginY, [UIScreen mainScreen].bounds.size.width - 2 * marginX, 1);
        view.backgroundColor = AJBlackColor(0.3f);
        [self.view addSubview:view];
        view;
    });
    
    self.enterButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(marginX, CGRectGetMaxY(self.secondLineView.frame) + marginTop, [UIScreen mainScreen].bounds.size.width - 2 * marginX, buttonHeight);
        button.titleLabel.font = [UIFont boldSystemFontOfSize: buttonFont];
        button.layer.cornerRadius = 5.0f;
        button.layer.masksToBounds = YES;
        button.enabled = NO;
        [button setTitle:@"进入社彩" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_login"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(enterSC:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
}

- (void)textChanged{
    if (self.passwordTextField.hasText && self.confirmPasswordTextField.hasText) {
        self.enterButton.enabled = YES;
    }
}

- (void)enterSC:(UIButton *)button{
    if (self.passwordTextField.text != self.confirmPasswordTextField.text) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"两次输入密码不一致" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
