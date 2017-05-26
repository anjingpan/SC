//
//  AJSelectMemberTableViewCell.m
//  SC
//
//  Created by 潘安静 on 2017/5/25.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSelectMemberTableViewCell.h"

@implementation AJSelectMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView layoutIfNeeded];
    
    self.nemeLabel.text = @"专属的一秒";
    self.iconImageView.image = [UIImage imageNamed:@"Me_Placeholder"];
    [self addRoundRect:self.iconImageView];
}

- (void)addRoundRect:(UIImageView *)imageView{
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:imageView.frame.size.width * 0.5] addClip];
    [imageView drawRect:imageView.bounds];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - Setter
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    self.selectImageView.image = isSelected ? [UIImage imageNamed:@"NewPage_Selected"] :[UIImage imageNamed:@"NewPage_Select"];
}

@end
