//
//  AJSchoolTableViewController.m
//  SC
//
//  Created by mac on 17/3/20.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchoolTableViewController.h"
#import "AJSchoolClubTableViewCell.h"
#import "AJSearchViewController.h"
#import "AJSchoolClubTableViewController.h"
#import "AJNewsViewController.h"
#import "MJRefresh.h"
#import "AJSchoolClub+Request.h"
#import "YYModel.h"

static CGFloat const kScrollTime = 3.f;  /**< 计时器时间*/
static NSString *const kSchoolTableViewCell = @"schoolTableViewCell";   /**< 社团列表重用标识符*/

@interface AJSchoolTableViewController ()

@property (nonatomic, strong) UIView *headerView;                   /**< tableView头视图*/
@property (nonatomic, strong) UIScrollView *hotClubScrollView;      /**< 热门滚动视图*/
@property (nonatomic, strong) UIPageControl *pageControl;           /**< 页数控制*/
@property (nonatomic, strong) NSTimer *timer;                       /**< 计时器*/
@property (nonatomic, strong) NSMutableArray *imageArray;           /**< 热门的图片数组*/
@property (nonatomic, assign) NSInteger currentPage;                /**< 当前页数*/

@property (nonatomic, assign) NSInteger pageNum;                    /**< 请求页数*/
@property (nonatomic, strong) NSMutableArray *clubArray;            /**< 社团数组*/
@end

@implementation AJSchoolTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.title = @"校园";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"School_Search"] style:UIBarButtonItemStyleDone target:self action:@selector(pushSearchController)];
    
    //静态数据
    self.imageArray = [[NSMutableArray alloc] init];
    //前后分别添加最后一个，以及第一个数据
    self.imageArray = [NSMutableArray arrayWithArray:@[@"SchoolHotNews_4",@"SchoolHotNews_1",@"SchoolHotNews_2",@"SchoolHotNews_3",@"SchoolHotNews_4",@"SchoolHotNews_1"]];
    
    [self initHeaderView];
    
    //添加下拉刷新和上拉加载控件
    [self shouldAddPullToRefresh:YES];
    [self shouldAddPushToRefresh:YES];
    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AJSchoolClubTableViewCell" bundle:nil] forCellReuseIdentifier:kSchoolTableViewCell];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init View
- (void)initHeaderView{
    self.currentPage = 0;
    
    //原型数据
    CGFloat scrollViewHeight = [[UIScreen mainScreen] bounds].size.width * 0.5;
    CGFloat pageControlHeight = 30;
    CGFloat divisionHeight = 10;
    CGFloat scrollViewPage = self.imageArray.count;
    
    self.headerView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, scrollViewHeight + divisionHeight);
        self.tableView.tableHeaderView = view;
        view;
    });
    
    //通过首尾各多添加一个图片视图来实现首尾循环滑动
    self.hotClubScrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, scrollViewHeight);
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width * scrollViewPage, scrollViewHeight);
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, scrollView.contentOffset.y);
        
        for (int i = 0; i < scrollViewPage; i ++) {
            CGFloat originX = i * [[UIScreen mainScreen] bounds].size.width;
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(originX, 0, [[UIScreen mainScreen] bounds].size.width, scrollViewHeight);
            imageView.image = [UIImage imageNamed:self.imageArray[i]];
            [scrollView addSubview:imageView];
        }
        [self.headerView addSubview:scrollView];
        
        //为轮播图添加点击事件
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollView)];
        [scrollView addGestureRecognizer:tapGesture];
        scrollView;
    });
    
    self.pageControl = ({
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.frame = CGRectMake(0, scrollViewHeight - pageControlHeight, [[UIScreen mainScreen] bounds].size.width, pageControlHeight);
        //图片数组添加的首尾数据是为了循环滑动
        pageControl.numberOfPages = scrollViewPage - 2;
        pageControl.currentPageIndicatorTintColor = AJBarColor;
        [self.headerView addSubview:pageControl];
        pageControl;
    });
    
    [self addTimer];
}

#pragma mark - Load Data
- (void)loadNewData{
    self.pageNum = 1;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"nowPage"] = @(self.pageNum);
    
    [AJSchoolClub getSchoolClubRequestWithParams:params SuccessBlock:^(id object) {
        self.clubArray = (NSMutableArray *)[NSArray yy_modelArrayWithClass:[AJSchoolClub class] json:object[@"data"][@"list"]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (self.pageNum >= [object[@"totalPage"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self reset];
        }
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
}

- (void)loadMoreData{
    self.pageNum ++;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"nowPage"] = @(self.pageNum);
    
    [AJSchoolClub getSchoolClubRequestWithParams:params SuccessBlock:^(id object) {
        [self.clubArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[AJSchoolClub class] json:object[@"data"][@"list"]]];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (self.pageNum >= [object[@"totalPage"] integerValue]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
}

#pragma mark - Button Click
- (void)pushSearchController{
    AJSearchViewController *searchVC = [[AJSearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)tapScrollView{
    AJNewsViewController *VC = [[AJNewsViewController alloc] init];
    VC.hidesBottomBarWhenPushed = true;
    NSLog(@"第%li页",(long)self.currentPage);
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Timer
- (void)addTimer{
    if (self.timer == nil) {
        self.timer = [NSTimer timerWithTimeInterval:kScrollTime target:self selector:@selector(scrollNext) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)scrollNext{
    [self.hotClubScrollView setContentOffset:CGPointMake((self.currentPage + 2) * [UIScreen mainScreen].bounds.size.width, self.hotClubScrollView.contentOffset.y) animated:YES];
}

#pragma mark - ScrollView Delagate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![scrollView isEqual:self.hotClubScrollView]) {
        return;
    }

    if (scrollView.contentOffset.x >= (self.currentPage + 2) * [UIScreen mainScreen].bounds.size.width) {
        self.currentPage ++;
        if (self.currentPage == self.imageArray.count - 2) {
            self.currentPage = 0;
            scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, scrollView.contentOffset.y);
        }
    }
    
    if (scrollView.contentOffset.x <= self.currentPage * [UIScreen mainScreen].bounds.size.width) {
        self.currentPage --;
        if (self.currentPage == -1) {
            self.currentPage = self.imageArray.count - 3;
            scrollView.contentOffset = CGPointMake((self.currentPage + 1) * [UIScreen mainScreen].bounds.size.width, scrollView.contentOffset.y);
        }
    }
    
    self.pageControl.currentPage = self.currentPage;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self addTimer];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.clubArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AJSchoolClubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSchoolTableViewCell];
    
    if (!cell) {
        cell = [[AJSchoolClubTableViewCell alloc] init];
    }
    
    cell.schoolClubMessage = self.clubArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    AJSchoolClubTableViewController *clubVC = [[AJSchoolClubTableViewController alloc] init];
    clubVC.clubID = ((AJSchoolClub *)self.clubArray[indexPath.row]).Groupid;
    //隐藏工具栏
    clubVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:clubVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
