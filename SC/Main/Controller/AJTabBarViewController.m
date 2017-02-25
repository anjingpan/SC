//
//  AJTabBarViewController.m
//  SC
//
//  Created by 潘安静 on 2017/2/25.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJTabBarViewController.h"

@interface AJTabBarViewController ()

@end

@implementation AJTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置Tab文字和图片选中颜色
    self.tabBar.tintColor = AJBarColor;
    
//    UITabBarItem *item = [UITabBarItem appearance];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[NSForegroundColorAttributeName] = AJBarColor;
//    [item setTitleTextAttributes:dic forState:UIControlStateSelected];
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
