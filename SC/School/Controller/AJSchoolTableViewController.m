//
//  AJSchoolTableViewController.m
//  SC
//
//  Created by mac on 17/3/20.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchoolTableViewController.h"

static CGFloat const kScrollTime = 3.f;
@interface AJSchoolTableViewController ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *hotClubScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AJSchoolTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"校园";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"School_Search"] style:UIBarButtonItemStyleDone target:self action:@selector(pushSearchController)];
    
    [self initHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init View
- (void)initHeaderView{
    
    //原型数据
    CGFloat scrollViewHeight = [[UIScreen mainScreen] bounds].size.width * 0.5;
    CGFloat pageControlHeight = 30;
    CGFloat scrollViewPage = 4;
    self.headerView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, scrollViewHeight);
        self.tableView.tableHeaderView = view;
        view;
    });
    
    self.hotClubScrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, scrollViewHeight);
        scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width * scrollViewPage, scrollViewHeight);
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        for (int i = 0; i < scrollViewPage; i ++) {
            CGFloat originX = i * [[UIScreen mainScreen] bounds].size.width;
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(originX, 0, [[UIScreen mainScreen] bounds].size.width, scrollViewHeight);
            imageView.image = [UIImage imageNamed:@"TabBar_Club"];
            [scrollView addSubview:imageView];
        }
        [self.headerView addSubview:scrollView];
        scrollView;
    });
    
    self.pageControl = ({
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.frame = CGRectMake(0, scrollViewHeight - pageControlHeight, [[UIScreen mainScreen] bounds].size.width, pageControlHeight);
        pageControl.numberOfPages = scrollViewPage;
        pageControl.currentPageIndicatorTintColor = AJBarColor;
        [self.headerView addSubview:pageControl];
        pageControl;
    });
    
    [self addTimer];
}

#pragma mark - Button Click
- (void)pushSearchController{
    
}

#pragma mark - Timer
- (void)addTimer{
    self.timer = [NSTimer timerWithTimeInterval:kScrollTime target:self selector:@selector(scrollNext) userInfo:nil repeats:YES];
}

- (void)scrollNext{
    
}

#pragma mark - ScrollView Delagate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![scrollView isEqual:self.hotClubScrollView]) {
        return;
    }
    NSInteger pageCount = scrollView.contentOffset.x / [[UIScreen mainScreen] bounds].size.width;
    self.pageControl.currentPage = pageCount;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


@end
