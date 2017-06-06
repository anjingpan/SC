//
//  AJBaseTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/6/3.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJBaseTableViewController.h"
#import "AJNavigationViewController.h"
#import "MBProgressHUD.h"
#import "AJProfile.h"
#import <MJRefresh.h>

@interface AJBaseTableViewController ()

@end

@implementation AJBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_TOKEN_KEY];
    if ([token isEqualToString:@""] || token == nil) {
        
        //跳转到登录界面
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //需要加上导航控制器
        AJNavigationViewController *navigationControoler = [[AJNavigationViewController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:IDENTIFIER_AJLOGINVIEWCONTROLLER]];
        [UIApplication sharedApplication].keyWindow.rootViewController = navigationControoler;
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MJRefresh
- (void)shouldAddPullToRefresh:(BOOL)isAdd{
    if (isAdd) {
        NSMutableArray *imageArray = [NSMutableArray array];
        
        for (int i = 1; i <= 17; i ++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_refresh_%i",i]];
            [imageArray addObject:image];
                        
        }
        
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        header.lastUpdatedTimeLabel.hidden = true;
        header.stateLabel.hidden = true;
        [header setImages:imageArray forState:MJRefreshStateRefreshing];
        //UIImageView *imageView = [header valueForKey:@"gifView"];
        //imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.tableView.mj_header = header;
    }else{
        self.tableView.mj_header = nil;
    }
}

- (void)shouldAddPushToRefresh:(BOOL)isAdd{
    if (isAdd) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        self.tableView.mj_footer = footer;
    }else{
        self.tableView.mj_footer = nil;
    }
}

- (void)loadNewData{
    
}

- (void)loadMoreData{
    
}

//下拉刷新后可以重新上拉加载
- (void)reset {
    [self.tableView.mj_footer setRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_footer resetNoMoreData];
}

#pragma mark - 错误处理

- (void)failErrorWithView:(UIView *)view error:(NSError *)error{
    UIView *MBProgressView = [MBProgressHUD HUDForView:view ];
    if (MBProgressView) {
        [MBProgressHUD hideHUDForView:view animated:YES];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    view = view ? : [[UIApplication sharedApplication] keyWindow];
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
