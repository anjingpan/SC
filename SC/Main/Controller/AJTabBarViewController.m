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
#import "AJNewPageViewController.h"

@interface AJTabBarViewController ()<AJNewPageViewControllerDelegate>

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
        AJNewPageViewController *viewController = [[AJNewPageViewController alloc] init];
        //当前页面不 dismiss，保证在退出页面的虚化透明背景下可以看到当前页面
        viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        viewController.delegate = self;
        [self presentViewController:viewController animated:YES completion:nil];
    };
}

#pragma mark - AJNewPageViewController Delegate
- (void)selectCollectionViewCellWithSection:(NSInteger)section{
    switch (section) {
        case 0:
            //新建社团
            
            break;
        case 1:
            //发送通知
            
            break;
        case 2:
            //发起审批
            
            break;
        case 3:
            //新建日程
            
            break;
    }
}

@end
