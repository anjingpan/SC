//
//  AJMessageLabel.m
//  SC
//
//  Created by 潘安静 on 2017/5/26.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJMessageLabel.h"
#import "UIImageView+RoundRect.h"

@interface AJMessageLabel ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *userNamelabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *clubNameLabel;
@end

@implementation AJMessageLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (void)layoutSubviews{
    self.iconImageView.frame = self.bounds;
    
    CGFloat marginX = 12.0;
    CGFloat timeLabelWidth = 38.0;
    CGFloat marginMaxY = 12.0;
    CGFloat marginMinY = 8.0;
    CGFloat timeLabelHeight = 14.0;
    CGFloat iconImageViewHeight = 14.0;
    
    self.iconImageView.frame = CGRectMake(marginX, marginMaxY, iconImageViewHeight, iconImageViewHeight);
    self.userNamelabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + marginX, marginMaxY, self.frame.size.width - CGRectGetMaxX(self.iconImageView.frame) - marginX, iconImageViewHeight);
    self.contentLabel.frame = CGRectMake(marginX, CGRectGetMaxY(self.iconImageView.frame) + marginMinY, self.frame.size.width - 2 * marginX, self.frame.size.height - timeLabelHeight - marginMaxY - 2 * marginMinY - CGRectGetMaxY(self.iconImageView.frame));//将时间标签以及用户头像视图中间的区域作为内容的高度
    
    if (self.type == messageTypeDetail) {
        self.timeLabel.hidden = YES;
        self.clubNameLabel.frame = CGRectMake(marginX, CGRectGetMaxY(self.contentLabel.frame) + marginMaxY , self.frame.size.width - 2 * marginX, timeLabelHeight);
    }else{
        self.timeLabel.frame = CGRectMake(marginX, CGRectGetMaxY(self.contentLabel.frame) + marginMaxY , timeLabelWidth, timeLabelHeight);
        self.clubNameLabel.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame) + marginX, self.timeLabel.frame.origin.y, self.frame.size.width - CGRectGetMaxX(self.timeLabel.frame) - 2 * marginX, timeLabelHeight);
    }
    
    [self.iconImageView addRoundRectWithCornerRadius:self.iconImageView.frame.size.width * 0.5];
}

#pragma mark - Init View
- (void)initView{
    [self layoutIfNeeded];
    self.backgroundColor = [UIColor whiteColor];
    
    
    //原型数据

    CGFloat maxFontSize = 14.0;
    CGFloat minFontSize = 10.0;
    
    self.iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"Me_Placeholder"];
        [self addSubview:imageView];
        imageView;
    });
    
    self.userNamelabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:minFontSize];
        label.textColor = [UIColor lightGrayColor];
        label.text = @"木然、";
        [self addSubview:label];
        label;
    });
    
    self.contentLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:maxFontSize];
        label.text = @"集合吃我脚";
        [self addSubview:label];
        label;
    });
    
    self.timeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:minFontSize];
        label.textColor = [UIColor lightGrayColor];
        label.text = @"16:39";
        [self addSubview:label];
        label;
    });
    
    self.clubNameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:minFontSize];
        label.textColor = [UIColor lightGrayColor];
        label.text = @"浙江工业大学学生会";
        [self addSubview:label];
        label;
    });
    
}

@end
