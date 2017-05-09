//
//  AJMeTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/3/5.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJMeTableViewController.h"
#import "AJMeInformationViewController.h"

static NSString *const kMeInformationSegue = @"meInformationSegue";

@interface AJMeTableViewController ()

@end

@implementation AJMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//通过 segue方法将个人信息界面设置为可编辑
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kMeInformationSegue]) {
        ((AJMeInformationViewController *)segue.destinationViewController).isAllowEdit = true;
    }
}

@end
