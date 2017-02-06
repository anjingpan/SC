//
//  AJPasswordTextField.m
//  SC
//
//  Created by 潘安静 on 2017/2/6.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJPasswordTextField.h"

@interface AJPasswordTextField ()

@property (nonatomic, strong)NSString *password;            /**< 保存密码*/
@property (nonatomic, weak) id beginEditingNotification;
@property (nonatomic, weak) id endEditingNotification;

@end

@implementation AJPasswordTextField

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame]) {
        [self initTextField];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initTextField];
    }
    return self;
}

- (void)initTextField{
    self.password = @"";
    
    __weak typeof(self) weakSelf = self;
    self.beginEditingNotification = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if (weakSelf == note.object && weakSelf.secureTextEntry) {
            weakSelf.text = @"";
            [weakSelf insertText:weakSelf.password];
        }
    }];
    
    self.endEditingNotification = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if (weakSelf == note.object) {
            weakSelf.password = weakSelf.text;
        }
    }];
}

#pragma mark - setter
- (void)setSecureTextEntry:(BOOL)secureTextEntry{
    BOOL isFirstResponder = self.isFirstResponder;
    [self resignFirstResponder];
    
    [super setSecureTextEntry:secureTextEntry];
    if (isFirstResponder) {
        [self becomeFirstResponder];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self.beginEditingNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self.endEditingNotification];
}

@end
