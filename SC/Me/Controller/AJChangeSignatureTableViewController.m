//
//  AJChangeSignatureTableViewController.m
//  SC
//
//  Created by mac on 17/3/13.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJChangeSignatureTableViewController.h"

static CGFloat const kMaxLength = 25;
@interface AJChangeSignatureTableViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *signatureTextView;

@end

@implementation AJChangeSignatureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改签名";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(changeSignature:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged) name:UITextViewTextDidChangeNotification object:nil];
    
    self.signatureTextView.delegate = self;
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
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    UITextRange *selectedRange = [textView markedTextRange];
//    UITextPosition *selectedPosition = [textView positionFromPosition:selectedRange.start offset:0];
//    
//    if (selectedRange && selectedPosition) {
//        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
//        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
//        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
//        
//        if (offsetRange.location < kMaxLength) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }
    
//}


@end
