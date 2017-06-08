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
#import "UIImageView+WebCache.h"

static NSString *const kMeInformationSegue = @"meInformationSegue";

@interface AJMeTableViewController ()
@property (nonatomic, strong) AJMember *userMember;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation AJMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        
//        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.userMember.imgurl] placeholderImage:[UIImage imageNamed:@"Me_Placeholder"] options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            self.iconImageView.frame = CGRectMake(22, 28, 64, 64);
//            self.iconImageView.contentMode = UIViewContentModeScaleToFill;
//            self.iconImageView.layer.cornerRadius = 32.0;
//            self.iconImageView.layer.masksToBounds = true;
//        }];
    } FailBlock:^(NSError * error) {
        [self failErrorWithView:self.view error:error];
    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.iconImageView.frame = CGRectMake(22, 28, 64, 64);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//通过 segue方法将个人信息界面设置为可编辑
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kMeInformationSegue]) {
        ((AJMeInformationViewController *)segue.destinationViewController).isAllowEdit = true;
    }
}

@end
