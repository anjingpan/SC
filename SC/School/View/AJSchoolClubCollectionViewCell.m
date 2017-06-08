//
//  AJSchoolClubCollectionViewCell.m
//  SC
//
//  Created by mac on 17/4/26.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchoolClubCollectionViewCell.h"

@interface AJSchoolClubCollectionViewCell ()


@end

@implementation AJSchoolClubCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentView layoutIfNeeded];
}

#pragma mark - Setter
- (void)setClubIconImageView:(UIImageView *)clubIconImageView{
    _clubIconImageView = clubIconImageView;
    
    clubIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    //暂时处理 cell 大小和定义的不一致问题，保证圆形
    clubIconImageView.layer.cornerRadius = [[UIScreen mainScreen] bounds].size.width / 12.0;
    clubIconImageView.layer.masksToBounds = YES;
    clubIconImageView.layer.borderWidth = 2.f;
    clubIconImageView.layer.borderColor = AJBackGroundColor.CGColor;
}

@end
