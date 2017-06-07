//
//  AJPasswordViewController.m
//  SC
//
//  Created by 潘安静 on 2017/2/20.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJPasswordViewController.h"
#import "AJPasswordTextField.h"
#import "AJAccount+Request.h"
#import "MBProgressHUD.h"
#import "YYModel.h"
#import "AJProfile.h"

@interface AJPasswordViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;                 /**< 背景图片视图*/
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
    
    self.backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.view.bounds;
        imageView.image = [UIImage imageNamed:@"Login_BackGround"];
        [self.view addSubview:imageView];
        imageView;
    });
    
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
        button.backgroundColor = [UIColor blackColor];
        button.titleLabel.font = [UIFont boldSystemFontOfSize: buttonFont];
        button.layer.cornerRadius = 5.0f;
        button.layer.masksToBounds = YES;
        button.alpha = 0.4;
        button.enabled = NO;
        [button setTitle:@"进入社彩" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(enterSC:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
}

- (void)textChanged{
    if (self.passwordTextField.hasText && self.confirmPasswordTextField.hasText) {
        self.enterButton.enabled = YES;
    }else{
        self.enterButton.enabled = NO;
    }
    
    self.enterButton.alpha = self.enterButton.enabled ? 1 : 0.4;
}

- (void)enterSC:(UIButton *)button{
    if (self.passwordTextField.text != self.confirmPasswordTextField.text) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"两次输入密码不一致" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phone"] = self.phoneText;
        params[@"password"] = self.passwordTextField.text;
        params[@"school"] = self.schoolText;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在设置中";
        
        [AJAccount registerRequestWithParams:params SuccessBlock:^(id object) {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"登录成功";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                AJAccount *account = [AJAccount yy_modelWithJSON:object[@"data"]];
                [[NSUserDefaults standardUserDefaults] setObject:account.access_token forKey:USERDEFAULT_TOKEN_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:account.uid forKey:USERDEFAULT_UID_KEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                [UIApplication sharedApplication].keyWindow.rootViewController = [mainStoryboard instantiateViewControllerWithIdentifier:IDENTIFIER_AJTABBARVIEWCONTROLLER];
            });
            
        } FailBlock:^(NSError *error) {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [NSString stringWithFormat:@"%@",error.userInfo[NSLocalizedDescriptionKey]? : @"服务器错误，稍后再试"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
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
