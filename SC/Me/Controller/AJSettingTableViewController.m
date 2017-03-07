//
//  AJSettingTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/3/6.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSettingTableViewController.h"

#define kCacheIndexpath [NSIndexPath indexPathForRow:1 inSection:0]
@interface AJSettingTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@end

@implementation AJSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath isEqual:kCacheIndexpath]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认清理" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
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
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:logout];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
