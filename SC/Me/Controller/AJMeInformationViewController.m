//
//  AJMeInformationViewController.m
//  SC
//
//  Created by mac on 17/3/9.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJMeInformationViewController.h"
#import "AJClubCollectionViewCell.h"

static NSString *const kClubCollectionViewCell = @"clubCollectionViewCell";

@interface AJMeInformationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *userIconImageView;      /**< 用户头像视图*/
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;              /**< 用户昵称标签*/
@property (strong, nonatomic) IBOutlet UILabel *userSchoolLabel;            /**< 用户学校标签*/
@property (strong, nonatomic) IBOutlet UILabel *userTitleLabel;             /**< 用户头衔标签*/
@property (strong, nonatomic) IBOutlet UILabel *userSignatureLable;         /**< 用户个性签名*/
@property (strong, nonatomic) IBOutlet UIImageView *clubIconImageView;      /**< 社团图标*/
@property (strong, nonatomic) IBOutlet UILabel *clubLabel;                  /**< 社团标签*/

@property (strong, nonatomic) UICollectionView *clubCollectionView;         /**< 社团列表*/
//@property (assign, nonatomic) CGFloat heightMargin;                       /**< 社团列表上下间距*/ //保证社团列表图片为正方形并且维持一定间距
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.clubCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.clubLabel.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.clubLabel.frame));
}

#pragma mark - Init View
- (void)initCollectionView{
    self.clubCollectionView = ({
        UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init];
        customLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:customLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerNib:[UINib nibWithNibName:@"AJClubCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kClubCollectionViewCell];
        [self.view addSubview:collectionView];
        collectionView;
    });
//    self.clubCollectionView.delegate = self;
//    self.clubCollectionView.dataSource = self;
//    [self.clubCollectionView registerNib:[UINib nibWithNibName:@"AJClubCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kClubCollectionViewCell];
}

#pragma mark - Button Click
- (void)editInformation:(UIBarButtonItem *)item{
    
}

#pragma mark - UiCollectionView Delegate && DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AJClubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kClubCollectionViewCell forIndexPath:indexPath];
    cell.clubImageView.image = [UIImage imageNamed:@"Me_Placeholder"];
    cell.clubNameLabel.text = @"学生会";
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake([UIScreen mainScreen].bounds.size.width / 3, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.clubLabel.frame));
    CGFloat sizeWidth = [UIScreen mainScreen].bounds.size.width / 3.0;
    CGFloat sizeHeight = [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.clubLabel.frame);
    return CGSizeMake(MIN(sizeWidth, sizeHeight - 20), MIN(sizeWidth, sizeHeight - 20));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
