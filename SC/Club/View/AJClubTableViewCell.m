//
//  AJClubTableViewCell.m
//  SC
//
//  Created by 潘安静 on 2017/3/30.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJClubTableViewCell.h"
#import "AJClubFunctionCollectionViewCell.h"

static NSString *const kClubFunctionCollectionCell = @"clubFunctionCollectionCell";  /**< 重用标识*/

@interface AJClubTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)UICollectionView *collectionView;           /**< 功能视图*/
@property(nonatomic, strong)NSArray *clubFunctionImageArray;            /**< 功能图片数组*/
@property(nonatomic, strong)NSArray *clubFunctionNameArray;             /**< 功能名字数组*/
@end

@implementation AJClubTableViewCell

#pragma mark - Init
- (instancetype)init{
    self = [super init];
    if (self) {
        //self.clubFunctionImageArray = @[@"Notification",@"Schedule",@"CashApproval",@"Approval",@"EmptySchedule",@"CashFlow",@"Address",@"More"];
        //self.clubFunctionNameArray = @[@"群发通知",@"日程管理",@"资金审批",@"场地审核",@"空课表",@"资金流动",@"通讯录",@"更多功能"];
        self.clubFunctionImageArray = @[@"Schedule",@"Address",@"More"];
        self.clubFunctionNameArray = @[@"日程管理",@"通讯录",@"更多功能"];
        
        self.collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 120 - 64 -44) collectionViewLayout:layout];
            collectionView.backgroundColor = [UIColor whiteColor];
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AJClubFunctionCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kClubFunctionCollectionCell];
            [self addSubview:collectionView];
            collectionView;
        });
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //self.clubFunctionImageArray = @[@"Notification",@"Schedule",@"CashApproval",@"Approval",@"EmptySchedule",@"CashFlow",@"Address",@"More"];
    //self.clubFunctionNameArray = @[@"群发通知",@"日程管理",@"资金审批",@"场地审核",@"空课表",@"资金流动",@"通讯录",@"更多功能"];
    self.clubFunctionImageArray = @[@"Schedule",@"Address",@"More"];
    self.clubFunctionNameArray = @[@"日程管理",@"通讯录",@"更多功能"];
    
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.25, 150);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AJClubFunctionCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kClubFunctionCollectionCell];
        [self addSubview:collectionView];
        collectionView;
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - CollectionViewDelegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.clubFunctionImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AJClubFunctionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kClubFunctionCollectionCell forIndexPath:indexPath];
    
    cell.functionImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Club_%@",self.clubFunctionImageArray[indexPath.item]]];
    cell.functionLabel.text = self.clubFunctionNameArray[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickBlock) {
        self.clickBlock(indexPath.row);
    }
    
}

#pragma mark - CollectionViewLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.25, 140);
}

@end
