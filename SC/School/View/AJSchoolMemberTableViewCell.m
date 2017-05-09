//
//  AJSchoolMemberTableViewCell.m
//  SC
//
//  Created by mac on 17/5/9.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJSchoolMemberTableViewCell.h"

@interface AJSchoolMemberTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *memberIconImageView;        /**< 成员头像视图*/
@property (strong, nonatomic) IBOutlet UILabel *memberNameLabel;                /**< 成员名称标签*/
@property (strong, nonatomic) IBOutlet UILabel *memberPositionLabel;            /**< 成员职位标签*/

@end

@implementation AJSchoolMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView layoutIfNeeded];
    
    [self addCornerRect:self.memberIconImageView];
    self.imageView.backgroundColor = [UIColor redColor];
    self.memberIconImageView.image = [UIImage imageNamed:@"Me_Placeholder"];
    self.memberNameLabel.text = @"专属的一秒";
    self.memberPositionLabel.text = @"社员";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addCornerRect:(UIImageView *)imageView{
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:imageView.frame.size.width * 0.5] addClip];
    [imageView drawRect:imageView.bounds];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
