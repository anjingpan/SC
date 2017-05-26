//
//  AJNewNotificationTableViewCell.m
//  SC
//
//  Created by 潘安静 on 2017/5/24.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNewNotificationTableViewCell.h"

@interface AJNewNotificationTableViewCell ()
@property(nonatomic, strong)UIView *divisionView;

@end

@implementation AJNewNotificationTableViewCell

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - InitView
- (void)initView{
    //原型数据
    CGFloat marginX = 12.0;
    CGFloat labelWidth = 72.0;
    CGFloat marginY = 10.0;
    CGFloat labelFontSize = 14.0;
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(marginX, marginY, labelWidth, self.frame.size.height - 2 * marginY);
        label.font = [UIFont systemFontOfSize:labelFontSize];
        [self addSubview:label];
        label;
    });
    
    self.divisionView = ({
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(marginX, self.frame.size.height - 1, [UIScreen mainScreen].bounds.size.width - marginX, 1);
        view.backgroundColor = AJBackGroundColor;
        [self addSubview:view];
        view;
    });
}

#pragma mark - Switch Click
- (void)changeSwitch:(UISwitch *)cellSwitch{
    if (self.switchBlock) {
        self.switchBlock(cellSwitch);
    }
}

#pragma mark - Setter
- (void)setStyle:(NewNotiViewCellStyle)style{
    _style = style;
    
    //原型数据
    CGFloat marginX = 12.0;
    CGFloat marginY = 8.0;
    CGFloat switchWidth = 48.0;
    CGFloat labelFontSize = 14.0;
    
    switch (style) {
        case NewNotiViewCellStyleSwitch:
            self.cellSwitch = ({
                UISwitch *cellSwitch = [[UISwitch alloc] init];
                cellSwitch.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - marginX - switchWidth, marginY, switchWidth, self.frame.size.height - 2 *marginY);
                [cellSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                [self addSubview:cellSwitch];
                cellSwitch;
            });
            break;
            
        default:
            self.detailLbael = ({
                UILabel *label = [[UILabel alloc] init];
                label.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + marginX, marginY, self.frame.size.width - CGRectGetMaxX(self.titleLabel.frame) - 2 * marginX, self.frame.size.height - 2 * marginY);
                label.font = [UIFont systemFontOfSize:labelFontSize];
                label.textAlignment = NSTextAlignmentRight;
                [self addSubview:label];
                label;
            });
            break;
    }
}


@end
