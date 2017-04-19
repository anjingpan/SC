//
//  AJTabBarViewController.m
//  SC
//
//  Created by 潘安静 on 2017/2/25.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJTabBarViewController.h"
#import "UITabBar+TrackPoint.h"
#import "AJTabBar.h"

@interface AJTabBarViewController ()

@end

@implementation AJTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置Tab文字和图片选中颜色
    self.tabBar.tintColor = AJBarColor;
    //为 tabBar添加小红点
    [self.tabBar addTrackPointWithItemIndex:1 tabBarNum:5];
    
    [self clickAddButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click
- (void)clickAddButton{
    ((AJTabBar*)self.tabBar).clickAddButtonBlock = ^(UIButton *button){
        
    };
}

@end
