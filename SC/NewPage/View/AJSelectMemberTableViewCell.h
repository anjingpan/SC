//
//  AJSelectMemberTableViewCell.h
//  SC
//
//  Created by 潘安静 on 2017/5/25.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJSchoolClub.h"
#import "AJMember.h"

@interface AJSelectMemberTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) AJSchoolClub *schoolClub;
@property (nonatomic, strong) AJMember *clubMember;


@end
