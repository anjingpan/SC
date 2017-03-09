//
//  AJMeInformationViewController.m
//  SC
//
//  Created by mac on 17/3/9.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJMeInformationViewController.h"

@interface AJMeInformationViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *userIconImageView;      /**< 用户头像视图*/
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;              /**< 用户昵称标签*/
@property (strong, nonatomic) IBOutlet UILabel *userSchoolLabel;            /**< 用户学校标签*/
@property (strong, nonatomic) IBOutlet UILabel *userTitleLabel;             /**< 用户头衔标签*/
@property (strong, nonatomic) IBOutlet UILabel *userSignatureLable;         /**< 用户个性签名*/
@property (strong, nonatomic) IBOutlet UIImageView *clubIconImageView;      /**< 社团图标*/
@property (strong, nonatomic) IBOutlet UILabel *clubLabel;                  /**< 社团标签*/

@property (strong, nonatomic) UICollectionView *clubCollectionView;         /**< 社团列表*/
@end

@implementation AJMeInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    //头像圆形化
    self.userIconImageView.backgroundColor = [UIColor whiteColor];
    self.userIconImageView.layer.masksToBounds = YES;
    self.userIconImageView.layer.cornerRadius = 40.f; //该控件宽高为80*80，但此处获取为1000*1000
    self.userIconImageView.layer.borderWidth = 1.f;
    self.userIconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Me_Edit"] style:UIBarButtonItemStyleDone target:self action:@selector(editInformation:)];
    
    [self initCollectionView];
}

- (void)initCollectionView{
    
}

- (void)editInformation:(UIBarButtonItem *)item{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
