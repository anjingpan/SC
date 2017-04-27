//
//  AJSchoolClubCollectionViewCell.m
//  SC
//
//  Created by mac on 17/4/26.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchoolClubCollectionViewCell.h"

@interface AJSchoolClubCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *clubIconImageView;

@end

@implementation AJSchoolClubCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.contentView layoutIfNeeded];
}

#pragma mark - Setter
- (void)setIconImage:(UIImage *)iconImage{
    _iconImage = iconImage;
    self.clubIconImageView.image = iconImage;
    self.clubIconImageView.contentMode = UIViewContentModeCenter;
    //暂时处理 cell 大小和定义的不一致问题，保证圆形
    self.clubIconImageView.layer.cornerRadius = [[UIScreen mainScreen] bounds].size.width / 12.0;
    self.clubIconImageView.layer.masksToBounds = YES;
    self.clubIconImageView.layer.borderWidth = 2.f;
    self.clubIconImageView.layer.borderColor = AJBackGroundColor.CGColor;
}

@end
