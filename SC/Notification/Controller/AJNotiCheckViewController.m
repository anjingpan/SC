//
//  AJNotiCheckViewController.m
//  SC
//
//  Created by 潘安静 on 2017/5/27.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNotiCheckViewController.h"
#import "AJMeInformationViewController.h"
#import "AJProfile.h"

static NSString *const kNotiCheckTableViewCell = @"notiCheckTableViewCell";

@interface AJNotiCheckViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AJNotiCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认详情";
    self.view.backgroundColor = AJBackGroundColor;
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init View
- (void)initView{
    
    //原型数据
    CGFloat marginX = 18.0;
    CGFloat marginY = 8.0;
    CGFloat segmentHeight = 32.0;
    
    self.segmentControl = ({
        UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"未确认",@"已确认"]];
        segmentControl.frame = CGRectMake(marginX, marginY + 64.0, [UIScreen mainScreen].bounds.size.width - 2 * marginX, segmentHeight);
        segmentControl.backgroundColor = [UIColor whiteColor];
        segmentControl.tintColor = AJBarColor;
        segmentControl.selectedSegmentIndex = 0;
        [segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
        [segmentControl addTarget:self action:@selector(segmentControlChangeIndex:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:segmentControl];
        segmentControl;
    });
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame) + marginY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.segmentControl.frame) - marginY) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
    
}

#pragma mark - Value Change
- (void)segmentControlChangeIndex:(UISegmentedControl *)segmentControl{
    [self.tableView reloadData];
}

#pragma mark - TableView Delegate && DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            return 2;
            break;
        case 1:
            return 5;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNotiCheckTableViewCell];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kNotiCheckTableViewCell];
    }
    
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"Me_Placeholder"];
            cell.textLabel.text = @"木然、";
            cell.detailTextLabel.text = @"";
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"Me_Placeholder"];
            cell.textLabel.text = @"木然、";
            cell.detailTextLabel.text = @"2017/5/28 01:04";
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //标志符在 storyboard中自己设置
    AJMeInformationViewController *informationViewController = [storyboard instantiateViewControllerWithIdentifier:IDENTIFIER_AJMEINFORMATIONVIEWCONTROLLER];
    informationViewController.isAllowEdit = false;
    [self.navigationController pushViewController:informationViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
