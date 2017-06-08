//
//  AJSchoolClubTableViewController.m
//  SC
//
//  Created by mac on 17/4/24.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchoolClubTableViewController.h"
#import "AJSchoolClubCollectionViewCell.h"
#import "AJSchoolMemberTableViewController.h"
#import "AJMeInformationViewController.h"
#import "AJProfile.h"
#import "AJSchoolClub+Request.h"
#import "MBProgressHUD.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"
#import "AJMember.h"

static NSString *const kSchoolClubCollectionViewCell = @"schoolClubCollectionViewCell";

@interface AJSchoolClubTableViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *headView;                     /**< 头部底视图*/
@property (nonatomic, strong) UIImageView *headerImageView;         /**< 头视图中底部 ImageView*/
@property (nonatomic, strong) UIImageView *clubImageView;           /**< 头像视图*/
@property (nonatomic, strong) UILabel *nameLabel;                   /**< 社团名称*/
@property (nonatomic, strong) UILabel *userCountLabel;              /**< 用户数量标签*/
@property (nonatomic, strong) UICollectionView *userCollectionView; /**< 用户头像列表*/
@property (nonatomic, strong) UILabel *introduceLabel;              /**< 社团简介*/
@property (nonatomic, strong) UIButton *readMoreButton;             /**< 查看全部简介*/
@property (nonatomic, strong) UIView *footView;                     /**< 尾部底视图*/
@property (nonatomic, strong) UIButton *applyJoinButton;            /**< 申请加入*/

@property (nonatomic, strong) NSArray *introduceConstraintsV;       /**< 简介标签约束*/ //要修改约束，所以定义
@property (nonatomic, assign) BOOL isMoreIntroduce;                 /**< 是否显示更多简介*/

@property (nonatomic, strong) AJSchoolClub *clubInfo;               /**< 社团信息*/
@end

@implementation AJSchoolClubTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isMoreIntroduce = NO;
    
    [self loadData];
    [self initHeaderView];
    [self initFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Data
- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"groupid"] = self.clubID;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.label.text = @"正在加载数据";

    [AJSchoolClub getClubInfoRequestWithParams:params SuccessBlock:^(id object) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        self.clubInfo = [AJSchoolClub yy_modelWithJSON:object[@"data"]];
        self.userCountLabel.text = [NSString stringWithFormat:@"现有成员%lu人",(unsigned long)self.clubInfo.user_list.count];
        [self.clubImageView sd_setImageWithURL:[NSURL URLWithString: self.clubInfo.imgurl] placeholderImage:[UIImage imageNamed:@"Me_Placeholder"] options:SDWebImageRefreshCached];
        [self.userCollectionView reloadData];
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
}

#pragma mark - Init View
- (void)initHeaderView{
    self.headView = ({
        UIView *view = [[UIView alloc] init];
        
        //不要将AutoresizingMask转为Autolayout的约束
        view.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.tableHeaderView = view;
        view;
    });
    
    self.headerImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.image = [UIImage imageNamed:@"School_Club_Background"];
        [self.headView addSubview:imageView];
        imageView;
    });
    
    self.clubImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.borderColor = AJBackGroundColor.CGColor;
        imageView.layer.cornerRadius = 10.f;
        imageView.layer.borderWidth = 2.f;
        imageView.layer.masksToBounds = YES;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.headerImageView addSubview:imageView];
        imageView;
    });
    
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16.f];
        label.textColor = [UIColor whiteColor];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.headerImageView addSubview:label];
        label;
    });
    
    self.userCountLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = [UIColor darkGrayColor];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.headView addSubview:label];
        label;
    });
    
    self.userCollectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AJSchoolClubCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kSchoolClubCollectionViewCell];
        [self.headView addSubview:collectionView];
        collectionView;
    });
    
    self.introduceLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = [UIColor blackColor];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 0;
        [self.headView addSubview:label];
        label;
    });
    
    self.readMoreButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"School_ReadMore"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(readMoreIntroduce:) forControlEvents:UIControlEventTouchUpInside];
        button.translatesAutoresizingMaskIntoConstraints = NO;
//        button.hidden = YES;
        [self.headView addSubview:button];
        button;
    });
    
    //添加约束
    [self addConstraint];
}

- (void)initFooterView{
    
    //原型数据
    CGFloat marginX = 12.f;
    CGFloat marginY = 12.f;
    CGFloat buttonHeight = 40.f;
    CGFloat fontSize = 18.f;
    CGFloat cornerRadius = 5.f;
    UIColor *buttonBackgroundColor = AJBarColor;
    UIColor *buttonTitleColor = [UIColor whiteColor];
    
    self.footView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, buttonHeight + 2 * marginY);
        self.tableView.tableFooterView = view;
        self.tableView.tableFooterView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        view;
    });
    
    self.applyJoinButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(marginX, marginY, [[UIScreen mainScreen] bounds].size.width - 2 * marginX, buttonHeight);
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        button.backgroundColor = buttonBackgroundColor;
        button.layer.cornerRadius = cornerRadius;
        button.layer.masksToBounds = YES;
        [button setTitleColor:buttonTitleColor forState:UIControlStateNormal];
        [button setTitle:@"申请加入" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(applyToJoin:) forControlEvents:UIControlEventTouchUpInside];
        [self.footView addSubview:button];
        button;
    });
}

#pragma mark - Add Constraint
- (void)addConstraint{
    
    NSArray *headViewConstrainV = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[_headerImageView(==180)]-30-[_userCountLabel(==30)]-[_userCollectionView(==%f)]-10-[_introduceLabel][_readMoreButton(==32)]-10-|",[[UIScreen mainScreen] bounds].size.width / 6.0] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headerImageView,_userCountLabel,_userCollectionView,_introduceLabel,_readMoreButton)];
    NSArray *headViewConstrainH = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|[_headView(==%f)]|",[[UIScreen mainScreen] bounds].size.width] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headView)];
    [self.tableView addConstraints:headViewConstrainH];
    [self.tableView addConstraints:headViewConstrainV];
    
    NSArray *headerImageViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_headerImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headerImageView)];
    NSArray *userCollectionViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_userCollectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_userCollectionView)];
    NSArray *introduceLabelH = [NSLayoutConstraint constraintsWithVisualFormat:@"|-12-[_introduceLabel]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_introduceLabel)];
    NSArray *readMoreButtonH = [NSLayoutConstraint constraintsWithVisualFormat:@"|-12-[_readMoreButton]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_readMoreButton)];
    //51为三行自适应高度后得到的高度
    self.introduceConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_introduceLabel(51)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_introduceLabel)];
    
    [self.headView addConstraints:headerImageViewH];
    [self.headView addConstraints:userCollectionViewH];
    [self.headView addConstraints:introduceLabelH];
    [self.headView addConstraints:readMoreButtonH];
    [self.headView addConstraints:self.introduceConstraintsV];
    [self.headView addConstraint:[NSLayoutConstraint constraintWithItem:self.userCountLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.headView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.headView addConstraint:[NSLayoutConstraint constraintWithItem:self.readMoreButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.headView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    NSArray *imageViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_clubImageView(==70)]-10-[_nameLabel(==30)]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_clubImageView,_nameLabel)];

    NSArray *clubImageViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"[_clubImageView(==70)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_clubImageView)];
    [self.headerImageView addConstraints:imageViewConstraintV];
    [self.headerImageView addConstraints:clubImageViewH];
    [self.headerImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.clubImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.headerImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.headerImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.headerImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    //添加约束后重新布局
    [self.view layoutIfNeeded];
}

#pragma mark - Button Click
- (void)readMoreIntroduce:(UIButton *)button{
    [NSLayoutConstraint deactivateConstraints:self.introduceConstraintsV];
    [self.view layoutIfNeeded];
    
    if (self.isMoreIntroduce) {
        self.introduceConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_introduceLabel(51)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_introduceLabel)];
        [self.headView addConstraints:self.introduceConstraintsV];
        button.transform = CGAffineTransformMakeRotation(0);
    }else{        
        //原型数据
        CGFloat fontSize = 14.f;
        CGFloat marginX = 12.f;
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
        CGRect labelFinalRect = [self.introduceLabel.text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 2 * marginX, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        self.introduceConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_introduceLabel(%f)]",labelFinalRect.size.height] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_introduceLabel)];
        button.transform = CGAffineTransformMakeRotation(M_PI);
    }
    
    [self.view layoutIfNeeded];
    
    //让 footerView的 frame可以随 headerView 改变而改变
    [self.tableView reloadData];
    self.isMoreIntroduce = !self.isMoreIntroduce;
}

- (void)applyToJoin:(UIButton *)button{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"groupid"] = self.clubID;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.label.text = @"提交申请中";
    [AJSchoolClub applySchoolClubRequestWithParams:params SuccessBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"提交申请成功";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:true];
            [self.navigationController popViewControllerAnimated:true];
        });
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark - CollectionView Delegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.clubInfo.user_list.count > 5) {
        return 5;
    }else if ( self.clubInfo.user_list.count){
        return self.clubInfo.user_list.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AJSchoolClubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSchoolClubCollectionViewCell forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[AJSchoolClubCollectionViewCell alloc] init];
    }
    
    if (self.clubInfo.user_list.count > 5 && indexPath.row == 4) {
        cell.clubIconImageView.image = [UIImage imageNamed:@"School_More"];
    }else{
        NSURL *iconURL = [NSURL URLWithString:((AJMember *)self.clubInfo.user_list[indexPath.row]).imgurl];
        
        [cell.clubIconImageView sd_setImageWithURL:iconURL placeholderImage:[UIImage imageNamed:@"Me_Placeholder"] options:SDWebImageRefreshCached];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width / 6.0, [[UIScreen mainScreen] bounds].size.width / 6.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4 && self.clubInfo.user_list.count > 5 ) {
        AJSchoolMemberTableViewController *memberViewController = [[AJSchoolMemberTableViewController alloc] init];
        [self.navigationController pushViewController:memberViewController animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        //标志符在 storyboard 中自己设置
        AJMeInformationViewController *informationViewController = [storyboard instantiateViewControllerWithIdentifier:IDENTIFIER_AJMEINFORMATIONVIEWCONTROLLER];
        informationViewController.userId = ((AJMember *)self.clubInfo.user_list[indexPath.row]).uid;
        [self.navigationController pushViewController:informationViewController animated:YES];
    }
}

#pragma mark - Setter
- (void)setClubInfo:(AJSchoolClub *)clubInfo{
    _clubInfo = clubInfo;
    
    self.nameLabel.text = clubInfo.Groupname;
    self.introduceLabel.text = clubInfo.introduction;
    
    //原型数据
    CGFloat fontSize = 14.f;
    CGFloat marginX = 12.f;
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
    CGRect labelFinalRect = [self.introduceLabel.text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 2 * marginX, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    //因为3行自适应后未51多，
    if (labelFinalRect.size.height < 52) {
        self.readMoreButton.hidden = YES;
    }else{
        self.readMoreButton.hidden = NO;
    }
}

@end
