//
//  AJChangePasswordTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/3/5.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJChangePasswordTableViewController.h"

@interface AJChangePasswordTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *originPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *freshPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation AJChangePasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStyleDone target:self action:@selector(changePassword)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self.originPasswordTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    [self.freshPasswordTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    [self.confirmPasswordTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
}

- (void)changePassword{
    
}

- (void)textChanged{
    if (self.originPasswordTextField.hasText && self.freshPasswordTextField.hasText && self.confirmPasswordTextField.hasText) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
