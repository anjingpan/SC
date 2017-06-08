//
//  AJSchoolClubTableViewCell.m
//  SC
//
//  Created by mac on 17/3/28.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchoolClubTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AJProfile.h"

@interface AJSchoolClubTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *schoolClubImageView;
@property (strong, nonatomic) IBOutlet UILabel *schoolClubNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *schoolClubAbstractLabel;

@end

@implementation AJSchoolClubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.schoolClubImageView.image = [UIImage imageNamed:@"Me_Placeholder"];
    self.schoolClubNameLabel.text = @"浙江工业大学学生会";
    self.schoolClubAbstractLabel.text = @"为所有浙江工业大学学生服务，学校最大学生组织";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter
- (void)setSchoolClubMessage:(AJSchoolClub *)schoolClubMessage{
    _schoolClubMessage = schoolClubMessage;
    [self.schoolClubImageView sd_setImageWithURL:[NSURL URLWithString:schoolClubMessage.imgurl] placeholderImage:[UIImage imageNamed:@"Me_Placeholder"] options:SDWebImageRefreshCached];
    self.schoolClubImageView.layer.cornerRadius = 5.0;
    self.schoolClubImageView.layer.masksToBounds = true;
    self.schoolClubNameLabel.text = schoolClubMessage.Groupname;
    self.schoolClubAbstractLabel.text = schoolClubMessage.introduction;
}

@end
