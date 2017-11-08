//
//  AJNavigationViewController.m
//  SC
//
//  Created by 潘安静 on 2016/12/21.
//  Copyright © 2016年 anjing. All rights reserved.
//

#import "AJNavigationViewController.h"

@interface AJNavigationViewController ()

@end

@implementation AJNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //导航栏状态栏黑色背景
    self.navigationBar.barTintColor = [UIColor blackColor];
    //状态栏字体白色
    self.navigationBar.barStyle = UIBarStyleBlack;
    //去除导航栏返回按钮文字
    //iOS11上这样会导致返回键向下偏移
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    //导航栏返回文字按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
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
