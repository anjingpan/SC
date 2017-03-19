//
//  AJFeedbackTableViewController.m
//  SC
//
//  Created by 潘安静 on 2017/3/6.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJFeedbackTableViewController.h"

@interface AJFeedbackTableViewController ()
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

@end

@implementation AJFeedbackTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
    //为 textView 添加 placeholder
    [self initTextViewPlaceholder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTextViewPlaceholder{
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = @"请输入你遇到的问题或建议...";
    placeholderLabel.textColor = [UIColor lightGrayColor];
    //保证 placeholder 字体和文本框字体一样大
    placeholderLabel.font = [UIFont systemFontOfSize:14.f];
    [self.feedbackTextView addSubview:placeholderLabel];
    
    [self.feedbackTextView setValue:placeholderLabel forKey:@"_placeholderLabel"];
}

- (IBAction)commitFeedBack:(id)sender {
}



@end
