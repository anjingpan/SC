//
//  AJSettingTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/3/6.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSettingTableViewController.h"
#import "AJAccount+Request.h"
#import "AJNavigationViewController.h"
#import "AJProfile.h"
#import "SDImageCache.h"

#define kCacheIndexpath [NSIndexPath indexPathForRow:1 inSection:0]
@interface AJSettingTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@end

@implementation AJSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    //获取图片缓存大小,iOS上KB = 1000B
    double size = [[SDImageCache sharedImageCache] getSize] / 1000.0 / 1000.0;
    
    self.cacheLabel.text = [NSString stringWithFormat:@"%.2fMB",size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath isEqual:kCacheIndexpath]) {
        //清理图片缓存
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认清理" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                //获取图片缓存大小,iOS上KB = 1000B
                double size = [[SDImageCache sharedImageCache] getSize] / 1000.0 / 1000.0;
                
                self.cacheLabel.text = [NSString stringWithFormat:@"%.2fMB",size];
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:confirm];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - logout
- (IBAction)logout:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"退出后将无法完全体验应用" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [AJAccount logoutRequestWithParams:params SuccessBlock:^(id object) {
            //清除 token
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULT_TOKEN_KEY];
            //跳转到登录界面
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //需要将导航控制器加上
            AJNavigationViewController *navigationControoler = [[AJNavigationViewController alloc] initWithRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:IDENTIFIER_AJLOGINVIEWCONTROLLER]];
            [UIApplication sharedApplication].keyWindow.rootViewController = navigationControoler;
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
        } FailBlock:^(NSError *error) {
            [self failErrorWithView:self.view error:error];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:logout];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
