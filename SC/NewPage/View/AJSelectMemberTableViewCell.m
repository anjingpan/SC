//
//  AJSelectMemberTableViewCell.m
//  SC
//
//  Created by 潘安静 on 2017/5/25.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSelectMemberTableViewCell.h"
#import "UIImageView+RoundRect.h"

@interface AJSelectMemberTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nemeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation AJSelectMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView layoutIfNeeded];
    
    self.nemeLabel.text = @"专属的一秒";
    self.iconImageView.image = [UIImage imageNamed:@"Me_Placeholder"];
}

#pragma mark - Setter
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    self.selectImageView.image = isSelected ? [UIImage imageNamed:@"NewPage_Selected"] :[UIImage imageNamed:@"NewPage_Select"];
}

- (void)setClubMember:(AJMember *)clubMember{
    self.nemeLabel.text = clubMember.RealName;
    [self.iconImageView setRoundImageUrlStr:clubMember.imgurl placeholder:nil WithCornerRadius:self.iconImageView.frame.size.width * 0.5 completed:nil];
}

- (void)setSchoolClub:(AJSchoolClub *)schoolClub{
    self.nemeLabel.text = schoolClub.Groupname;
    [self.iconImageView setRoundImageUrlStr:schoolClub.imgurl placeholder:nil WithCornerRadius:self.iconImageView.frame.size.width * 0.5 completed:nil];
}

@end
