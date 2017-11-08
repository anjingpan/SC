//
//  AJBaseViewController.m
//  SC
//
//  Created by 潘安静 on 2017/6/3.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJBaseViewController.h"
#import "AJNavigationViewController.h"
#import "MBProgressHUD.h"
#import "AJProfile.h"

@interface AJBaseViewController ()

@end

@implementation AJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_TOKEN_KEY];
    if ([token isEqualToString:@""] || token == nil) {
        
        //跳转到登录界面
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //需要将导航控制器加上
        AJNavigationViewController *navigationControoler = [[AJNavigationViewController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:IDENTIFIER_AJLOGINVIEWCONTROLLER]];
        [UIApplication sharedApplication].keyWindow.rootViewController = navigationControoler;
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)failErrorWithView:(UIView *)view error:(NSError *)error{
    UIView *MBProgressView = [MBProgressHUD HUDForView:view ];
    if (MBProgressView) {
        [MBProgressHUD hideHUDForView:view animated:YES];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    view = view ? : [[UIApplication sharedApplication] keyWindow];
    NSLog(@"code--%ld",(long)error.code);
    if (error.code == 4) {
        hud.label.text = @"登录失效,请重新登录";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:view animated:YES];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULT_TOKEN_KEY];
            
            //强制调用系统页面出现
            [self viewDidAppear:NO];
        });
    }else{
        hud.label.text = [NSString stringWithFormat:@"%@",error.userInfo[NSLocalizedDescriptionKey]? : @"服务器错误，稍后再试"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:view animated:YES];
        });
    }
}

@end
