//
//  AJChangeNicknameTableViewController.m
//  SC
//
//  Created by mac on 17/3/13.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJChangeNicknameTableViewController.h"

@interface AJChangeNicknameTableViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nicknameTextField;

@end

@implementation AJChangeNicknameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改昵称";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(changeNickname:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self.nicknameTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click
- (void)changeNickname:(UIBarButtonItem *)item{
    
}

#pragma mark - textField Event
- (void)textFieldChanged:(UITextField *)textField{
    if (textField.hasText) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

@end
