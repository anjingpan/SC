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

static CGFloat const kScrollTime = 3.f;  /**< 计时器时间*/
static NSString *const kSchoolTableViewCell = @"schoolTableViewCell";   /**< 社团列表重用标识符*/

@interface AJSchoolTableViewController ()

@property (nonatomic, strong) UIView *headerView;                   /**< tableView头视图*/
@property (nonatomic, strong) UIScrollView *hotClubScrollView;      /**< 热门滚动视图*/
@property (nonatomic, strong) UIPageControl *pageControl;           /**< 页数控制*/
@property (nonatomic, strong) NSTimer *timer;                       /**< 计时器*/
@property (nonatomic, strong) NSMutableArray *imageArray;           /**< 热门的图片数组*/
@property (nonatomic, assign) NSInteger currentPage;                /**< 当前页数*/
@end

@implementation AJSchoolTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = AJBackGroundColor;
    
    self.title = @"校园";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"School_Search"] style:UIBarButtonItemStyleDone target:self action:@selector(pushSearchController)];
    
    //静态数据
    self.imageArray = [[NSMutableArray alloc] init];
    //前后分别添加最后一个，以及第一个数据
    self.imageArray = [NSMutableArray arrayWithArray:@[@"TabBar_Me",@"TabBar_School",@"TabBar_Notification",@"TabBar_Club",@"TabBar_Me",@"TabBar_School"]];
    
    [self initHeaderView];
    
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

#pragma mark - Button Click
- (void)pushSearchController{
    AJSearchViewController *searchVC = [[AJSearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
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
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSchoolTableViewCell];
    
    if (!cell) {
        cell = [[AJSchoolClubTableViewCell alloc] init];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转页面时隐藏底部 TabBar
    self.hidesBottomBarWhenPushed = YES;
    AJSchoolClubTableViewController *clubVC = [[AJSchoolClubTableViewController alloc] init];
    [self.navigationController pushViewController:clubVC animated:YES];
    //跳转后不隐藏 TabBar
    self.hidesBottomBarWhenPushed = NO;
}

@end
