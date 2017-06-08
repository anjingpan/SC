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
#import "AJNewClubViewController.h"
#import "AJNewNotificationViewController.h"
#import "AJNewScheduleViewController.h"
#import "AJProfile.h"

@interface AJTabBarViewController ()<AJNewPageViewControllerDelegate>

@end

@implementation AJTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置Tab文字和图片选中颜色
    self.tabBar.tintColor = AJBarColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTrack:) name:NSNOTIFICATION_HASUNREAD object:nil];
    
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

- (void)addTrack:(NSNotification *)noti{
    NSDictionary *userInfo = noti.object;
    if ([userInfo[@"hasUnread"] isEqualToString:@"1"]) {
        [self.tabBar addTrackPointWithItemIndex:1 tabBarNum:5];
    }else{
        [self.tabBar removeTrackPointWithItemIndex:1];
    }
}

#pragma mark - AJNewPageViewController Delegate
- (void)selectCollectionViewCellWithSection:(NSInteger)section{
    UIViewController *VC;
    switch (section) {
        case 0:
            //新建社团
            VC = [[AJNewClubViewController alloc] init];
            break;
        case 1:
            //发送通知
            VC = [[AJNewNotificationViewController alloc] init];
            break;
//        case 2:
            //发起审批
            
//            break;
    }
    
    VC.hidesBottomBarWhenPushed = true;
    NSInteger tabBarIndex = [self.tabBar.items indexOfObject:self.tabBar.selectedItem];
    UINavigationController *navigationController = self.viewControllers[tabBarIndex];
    [navigationController pushViewController:VC animated:YES];
    
    if (section == 2) {
        //新建日程
        VC = [[AJNewScheduleViewController alloc] init];
        [self presentViewController:VC animated:YES completion:nil];
    }
}

@end
