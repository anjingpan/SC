//
//  AJScheduleDetailViewController.m
//  SC
//
//  Created by 潘安静 on 2017/6/2.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJScheduleDetailViewController.h"
#import "UILabel+AdaptSize.h"
#import "AJSchoolClubCollectionViewCell.h"
#import "AJNewScheduleViewController.h"

static NSString *const kScheduleDetailCollectionCell = @"scheduleDetailCollectionCell";

@interface AJScheduleDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *divisionView;
@property (nonatomic, strong) UILabel *dataLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation AJScheduleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"日程详情";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Me_Edit"] style:UIBarButtonItemStyleDone target:self action:@selector(editSchedule)];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Init View
- (void)initView{
    
    CGFloat marginX = 12.0;
    CGFloat marginY = 12.0;
    CGFloat timeLabelHeight = 16.0;
    CGFloat timeLabelFont = 14.0;
    CGFloat labelFont = 12.0;
    
    self.timeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, marginY + 64.0, [UIScreen mainScreen].bounds.size.width, timeLabelHeight);
        label.font = [UIFont systemFontOfSize:timeLabelFont];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.schedule.schedule_time;
        [self.view addSubview:label];
        label;
    });
    
    self.divisionView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(marginX, CGRectGetMaxY(self.timeLabel.frame) + marginY, [UIScreen mainScreen].bounds.size.width - 2 * marginX, 1);
        view.backgroundColor = AJBlackColor(0.75);
        [self.view addSubview:view];
        view;
    });
    
    self.dataLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(marginX, CGRectGetMaxY(self.divisionView.frame) + marginY, [UIScreen mainScreen].bounds.size.width - 2 * marginX, timeLabelHeight);
        label.text = self.schedule.content;
        label.font = [UIFont systemFontOfSize:labelFont];
        [label adaptHeightWithText:label.text WithFontSize:labelFont WithWidth:label.frame.size.width];
        [self.view addSubview:label];
        label;
    });
    
    self.collectionView = ({
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 2 * marginX) * 0.5, ([UIScreen mainScreen].bounds.size.width - 2 * marginX) * 0.5);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dataLabel.frame) + marginY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.dataLabel.frame) - marginY) collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AJSchoolClubCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kScheduleDetailCollectionCell];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self.view addSubview:collectionView];
        collectionView;
    });
}

#pragma mark - Button Click
- (void)editSchedule{
    AJNewScheduleViewController *VC = [[AJNewScheduleViewController alloc] init];
    VC.textString = self.dataLabel.text;
    [self presentViewController:VC animated:YES completion:nil];
}

#pragma mark - UICollectionView Delagate && DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AJSchoolClubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kScheduleDetailCollectionCell forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[AJSchoolClubCollectionViewCell alloc] init];
    }
    
    cell.clubIconImageView.image = [UIImage imageNamed:@"Me_Placeholder"];
    return cell;
}
@end
