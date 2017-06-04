//
//  AJClubCollectionViewCell.m
//  SC
//
//  Created by 潘安静 on 2017/3/12.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJClubCollectionViewCell.h"
#import "AJProfile.h"
#import "UIImageView+WebCache.h"

@interface AJClubCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *clubImageView; /**< 社团图片视图*/
@property (weak, nonatomic) IBOutlet UILabel *clubNameLabel;     /**< 社团名字视图*/

@end

@implementation AJClubCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setter
- (void)setClubMessage:(AJSchoolClub *)clubMessage{
    _clubMessage = clubMessage;
    
    NSURL *imageURL = [NSURL URLWithString:[CONST_URL_DOMAIN stringByAppendingString:clubMessage.imgurl]];
    [self.clubImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"Me_Placeholder"] options:SDWebImageRefreshCached];
    
    self.clubNameLabel.text = clubMessage.Groupname;
}

@end
