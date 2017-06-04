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
    //NSURL *imageURL = [NSURL URLWithString:[CONST_URL_DOMAIN stringByAppendingString:schoolClubMessage.imgurl]];
    NSURL *imageURL = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496607931052&di=e25d0dd424f84b87b10a7bead6f6b4ad&imgtype=0&src=http%3A%2F%2Ff7.topit.me%2F7%2F59%2F11%2F110711813807611597o.jpg"];
    NSLog(@"URLString--%@",[CONST_URL_DOMAIN stringByAppendingString:schoolClubMessage.imgurl]);
    [self.schoolClubImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"Me_Placeholder"] options:SDWebImageRefreshCached];
    self.schoolClubNameLabel.text = schoolClubMessage.Groupname;
    self.schoolClubAbstractLabel.text = schoolClubMessage.introduction;
}

@end
