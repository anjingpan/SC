//
//  AJFormTextField.m
//  SC
//
//  Created by mac on 17/5/10.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJFormTextField.h"

@interface AJFormTextField () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation AJFormTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initValues];
        [self initView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initValues];
        [self initView];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    UIBezierPath *borderPath = [UIBezierPath bezierPath];
    [borderPath moveToPoint:CGPointMake(0, self.frame.size.height)];
    [borderPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    borderLayer.path = borderPath.CGPath;
    borderLayer.strokeColor = self.borderColor.CGColor;
    borderLayer.borderWidth = self.borderWidth;
    [self.layer addSublayer:borderLayer];
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
    self.borderStyle = UITextBorderStyleNone;
    self.font = [UIFont systemFontOfSize:14.0];
    
    self.placeholderLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, self.frame.size.width, self.placeholderHeight);
        label.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        label.textColor = _placeholderTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        label;
    });
}

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.5 animations:^{
        self.placeholderLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.placeholderHeight);
    } completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        [UIView animateWithDuration:0.5 animations:^{
            self.placeholderLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.textEditHeight);
            self.placeholderLabel.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        } completion:nil];
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectMake(0, self.placeholderHeight, self.bounds.size.width, self.bounds.size.height - self.placeholderHeight);
}


#pragma mark - Setter
- (void)setPlaceholderText:(NSString *)placeholderText{
    _placeholderText = placeholderText;
    
    self.placeholderLabel.text = placeholderText;
}

@end
