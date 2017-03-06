//
//  AJSettingTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/3/6.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSettingTableViewController.h"

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
}

#pragma mark - logout
- (IBAction)logout:(id)sender {
}


@end
