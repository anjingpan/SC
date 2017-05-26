//
//  AJFormTextView.m
//  SC
//
//  Created by mac on 17/5/10.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJFormTextView.h"

@interface AJFormTextView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end

@implementation AJFormTextView

- (instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        [self initValues];
        [self initView];
    }
    
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initValues];
        [self initView];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    NSLog(@"%@",NSStringFromCGRect(self.frame));
    CAShapeLayer *border = [CAShapeLayer layer];
    UIBezierPath *borderPath = [UIBezierPath bezierPath];
    [borderPath moveToPoint:CGPointMake(0, self.frame.size.height)];
    [borderPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    border.path = borderPath.CGPath;
    border.strokeColor = self.borderColor.CGColor;
    border.borderWidth = self.borderWidth;
    self.borderLayer = border;
    [self.layer addSublayer:self.borderLayer];
}

#pragma mark - Init
- (void)initValues{
    _borderColor = AJBarColor;
    _borderWidth = 1.0;
    _placeholderHeight = 20;
    _textEditHeight = self.frame.size.height - _placeholderHeight;
    //_placeholderTextColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:218/255.0f alpha:1];
    _placeholderTextColor = [UIColor lightGrayColor];
}

- (void)initView{
    self.delegate = self;
    self.textContainerInset = UIEdgeInsetsMake(self.placeholderHeight, 0, 0, 0);
    self.font = [UIFont systemFontOfSize:14.0];
    
    self.placeholderLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, self.placeholderHeight, self.frame.size.width, self.placeholderHeight);
        label.textColor = _placeholderTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        label;
    });
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5 animations:^{
        self.placeholderLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.placeholderHeight);
    } completion:nil];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        [UIView animateWithDuration:0.5 animations:^{
            self.placeholderLabel.frame = CGRectMake(0, self.placeholderHeight, self.frame.size.width, self.placeholderHeight);
        } completion:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self]) {
        self.placeholderLabel.frame = CGRectMake(0, scrollView.contentOffset.y, self.frame.size.width, self.placeholderHeight);
        UIBezierPath *newPath = [UIBezierPath bezierPath];
        [newPath moveToPoint:CGPointMake(0, scrollView.contentOffset.y + self.frame.size.height)];
        [newPath addLineToPoint:CGPointMake(self.frame.size.width, scrollView.contentOffset.y + self.frame.size.height)];
        self.borderLayer.path = newPath.CGPath;        
    }
}

//可以查看 View 层级
- (void)_firstBaselineOffsetFromTop{
    
}
- (void)_baselineOffsetFromBottom{
    
}

#pragma mark - Setter
- (void)setPlaceholderText:(NSString *)placeholderText{
    _placeholderText = placeholderText;
    
    self.placeholderLabel.text = placeholderText;
}

@end
