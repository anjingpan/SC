//
//  AJSearchViewController.m
//  SC
//
//  Created by mac on 17/3/28.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSearchViewController.h"

@interface AJSearchViewController ()
@property (nonatomic, strong) UITextField *searchTextField;

@end

@implementation AJSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = AJBackGroundColor;
    
    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar{
    self.searchTextField = ({
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width - 60, 44);
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [UIColor whiteColor];
        textField.borderStyle = UITextBorderStyleNone;
        NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:@"输入关键词" attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
        textField.attributedPlaceholder = placeholderString;
        textField.backgroundColor = [UIColor clearColor];
        UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"School_Search"]];
        textField.leftView = searchImageView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField;
    });
    UIBarButtonItem *leftSearchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchTextField];
    self.navigationItem.leftBarButtonItem = leftSearchButtonItem;
    
    UIBarButtonItem *rightCancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSearch)];
    rightCancelButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightCancelButtonItem;
}

- (void)cancelSearch{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
