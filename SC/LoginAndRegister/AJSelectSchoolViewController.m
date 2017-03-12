//
//  AJSelectSchoolViewController.m
//  SC
//
//  Created by 潘安静 on 2017/2/19.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSelectSchoolViewController.h"
#import "AJPasswordViewController.h"

static NSString *const kSchoolTableViewCellReuseId = @"schoolTableViewCell";

@interface AJSelectSchoolViewController ()<UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *schoolTableView;          /**< 学校列表*/
@property (nonatomic, strong) UISearchController *searchController;  /**< 搜索控制器*/
@property (nonatomic, strong) NSMutableArray *dataArray;             /**< 原始数组*/
@property (nonatomic, strong) NSMutableArray *resultArray;           /**< 结果数组*/
@end

@implementation AJSelectSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择学校";
    self.view.backgroundColor = AJBackGroundColor;
    
    self.searchController = ({
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        searchController.searchResultsUpdater = self;
        searchController.searchBar.frame = CGRectMake(searchController.view.frame.origin.x, searchController.view.frame.origin.y, searchController.view.frame.size.width, 44);
        searchController.dimsBackgroundDuringPresentation = NO;
        searchController.searchBar.placeholder = @"输入大学名称或拼音查询";
        searchController;
    });
    
    self.schoolTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableHeaderView = self.searchController.searchBar;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSchoolTableViewCellReuseId];
        [self.view addSubview:tableView];
        tableView;
    });
    
    self.dataArray = [NSMutableArray arrayWithArray:@[@"浙江工业大学",@"浙江科技学院",@"杭州师范大学",@"浙江电子科技大学",@"中国计量大学",@"浙江大学城市学院",@"宁波大学",@"温州医科大学",@"温州大学",@"华东理工大学",@"石家庄医科大学",@"重庆大学",@"临沂大学",@"上海大学",@"西安交通大学",@"国防科技大学"]];
    self.resultArray = [NSMutableArray array];
}

#pragma mark - UITablViewDelegate &&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return self.resultArray.count;
    }else{
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:kSchoolTableViewCellReuseId];
    tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (self.searchController.active) {
        tableViewCell.textLabel.text = self.resultArray[indexPath.row];
    }else{
        tableViewCell.textLabel.text = self.dataArray[indexPath.row];
    }
    
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [self.schoolTableView cellForRowAtIndexPath:indexPath];
    UIViewController *VC = [[AJPasswordViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = self.searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",searchString];
    //移除原先的结果
    if (self.resultArray !=nil) {
        [self.resultArray removeAllObjects];
    }
    self.resultArray = [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:predicate]];
    [self.schoolTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
