//
//  AJSelectMemberTableViewCell.h
//  SC
//
//  Created by 潘安静 on 2017/5/25.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJSelectMemberTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nemeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end
