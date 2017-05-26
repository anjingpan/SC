//
//  AJFormTextField.h
//  SC
//
//  Created by mac on 17/5/10.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJFormTextField : UITextField

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) NSString *placeholderText;
@property (nonatomic, strong) UIColor *placeholderTextColor;
@property (nonatomic, assign) CGFloat textEditHeight;
@property (nonatomic, assign) CGFloat placeholderHeight;

@end
