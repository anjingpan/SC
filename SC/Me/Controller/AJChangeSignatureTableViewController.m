//
//  AJChangeSignatureTableViewController.m
//  SC
//
//  Created by mac on 17/3/13.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJChangeSignatureTableViewController.h"

static NSInteger const kMaxLength = 24;
@interface AJChangeSignatureTableViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *signatureTextView;
@property (weak, nonatomic) IBOutlet UILabel *leftCountLabel;

@end

@implementation AJChangeSignatureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改签名";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(changeSignature:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged) name:UITextViewTextDidChangeNotification object:nil];
    
    self.signatureTextView.delegate = self;
    self.leftCountLabel.text = [NSString stringWithFormat:@"%ld",kMaxLength];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Button Click
- (void)changeSignature:(UIBarButtonItem *)item{
    
}

#pragma mark - Notification
- (void)textViewChanged{
    if (self.signatureTextView.hasText) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //选中状态下的文字的范围
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *selectedPosition = [textView positionFromPosition:selectedRange.start offset:0];
    
    if (selectedRange && selectedPosition) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < kMaxLength) {
            return YES;
        }else{
            return NO;
        }
    }
    
    //正在输入的文字以及之前的文字
    NSString *comcatString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger leftLength = kMaxLength - comcatString.length;
    if (leftLength >= 0) {
        return YES;
    }else{
        NSInteger totalLength = text.length + leftLength;
        //多余文字的范围
        NSRange excessRange = NSMakeRange(0, MAX(totalLength, 0));
        if (excessRange.length > 0) {
            //在输入的文字中去除多余文字
            NSString *string = [text substringWithRange:excessRange];
            textView.text = [textView.text stringByReplacingCharactersInRange:range withString:string];
        }
        return NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *selectedPosition = [textView positionFromPosition:selectedRange.start offset:0];
    
    if (selectedRange && selectedPosition) {
        return;
    }
    
    if (textView.text.length > kMaxLength) {
        textView.text = [textView.text substringToIndex:kMaxLength];
    }
    
    self.leftCountLabel.text = [NSString stringWithFormat:@"%ld",kMaxLength - textView.text.length];
}


@end
