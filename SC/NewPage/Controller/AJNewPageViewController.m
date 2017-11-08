//
//  AJNewPageViewController.m
//  SC
//
//  Created by 潘安静 on 2017/4/22.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNewPageViewController.h"
#import "AJNewPageCollectionViewCell.h"

static NSString *const kNewPageCollectionViewCell = @"newPageCollectionViewCell";   /**< collectionView 重用标识*/

@interface AJNewPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *pageCollectionView;   /**< 新建collectionView*/
@property(nonatomic, strong) UIVisualEffectView *blurView;           /**< 背景虚化底视图*/
@property(nonatomic, strong) UIView *divisionView;                   /**< 分割视图*/
@property(nonatomic, strong) UIButton *closeButton;                  /**< 关闭按钮*/
@property(nonatomic, strong) NSArray *imageNameArray;                /**< collectionView图片名称数组*/
@property(nonatomic, strong) NSArray *labelTextArray;                /**< collectionView标签标题数组*/
@end

@implementation AJNewPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Data
- (void)initData{
    self.labelTextArray = @[@"新建社团",@"发送通知",@"添加日程"];
    self.imageNameArray = @[@"NewPage_Club",@"NewPage_Notification",@"NewPage_Schedule"];
}

#pragma mark - Init View
- (void)initView{
    //原型数据
    CGFloat marginY = 5.f;
    CGFloat divisionViewHeight = 1.f;
    //保证和外面的新建按钮一样大小
    CGFloat buttonHeight = 49.f - 2 * marginY - divisionViewHeight;      //49为 TabBar 高度
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width * 0.2 - 20.f;
    CGFloat buttonMarginX = ([UIScreen mainScreen].bounds.size.width - buttonWidth) * 0.5 + 10.f;
    
    CGFloat collectionViewHeight = 0.3 * [UIScreen mainScreen].bounds.size.height;  //collectionView高度
    
    //背景虚化视图
    self.blurView = ({
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        view.frame = self.view.frame;
        [self.view addSubview:view];
        view;
    });
    
    //关闭按钮
    self.closeButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //适配 iPhone X
        button.frame = CGRectMake(buttonMarginX, [UIScreen mainScreen].bounds.size.height - marginY - buttonHeight - kMarginBottom, buttonWidth, buttonHeight);
        [button setImage:[UIImage imageNamed:@"NewPage_Close"] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    //分割视图
    self.divisionView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, CGRectGetMinY(self.closeButton.frame) - marginY - divisionViewHeight, [UIScreen mainScreen].bounds.size.width, divisionViewHeight);
        view.backgroundColor = AJBackGroundColor;
        [self.view addSubview:view];
        view;
    });
    
    //新建collectionView
    self.pageCollectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.divisionView.frame) - collectionViewHeight - marginY, [UIScreen mainScreen].bounds.size.width, collectionViewHeight) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[AJNewPageCollectionViewCell class] forCellWithReuseIdentifier: kNewPageCollectionViewCell];
        [self.view addSubview:collectionView];
        collectionView;
    });
}

#pragma mark - CollectionView Delegate && Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.labelTextArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.2, [UIScreen mainScreen].bounds.size.width * 0.2 + 12 + 14);//12,14为文字标签的间距和高度
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AJNewPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNewPageCollectionViewCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[AJNewPageCollectionViewCell alloc] init];
    }
    cell.imageName = self.imageNameArray[indexPath.row];
    cell.labelText = self.labelTextArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(selectCollectionViewCellWithSection:)]) {
            [self.delegate selectCollectionViewCellWithSection:indexPath.row];
        }
    }];
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击不在 collectionView 上dismiss 页面
    UITouch *touch = touches.anyObject;
    CGPoint touchLocation = [touch locationInView:self.view];
    if (!CGRectContainsPoint(self.pageCollectionView.frame, touchLocation)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Button Click
- (void)clickCloseButton:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
