//
//  AJMeTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/3/5.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJMeTableViewController.h"
#import "AJMeInformationViewController.h"
#import "AJMember+Request.h"
#import "YYModel.h"
#import "UIImageView+RoundRect.h"

static NSString *const kMeInformationSegue = @"meInformationSegue";

@interface AJMeTableViewController ()
@property (nonatomic, strong) AJMember *userMember;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation AJMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Data
- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [AJMember getUserInfoRequestWithParams:params SuccessBlock:^(id object) {
        self.userMember = [AJMember yy_modelWithJSON:object[@"data"]];
        
        [self.iconImageView setRoundImageUrlStr:self.userMember.imgurl placeholder:nil WithCornerRadius:self.iconImageView.frame.size.width * 0.5];
    } FailBlock:^(NSError * error) {
        [self failErrorWithView:self.view error:error];
    }];

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
