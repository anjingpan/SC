//
//  AJMeSecurityTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/3/5.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJMeSecurityTableViewController.h"

@interface AJMeSecurityTableViewController ()

@end

@implementation AJMeSecurityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帐号安全";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
