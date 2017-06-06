//
//  AJNewPageCollectionViewCell.m
//  SC
//
//  Created by 潘安静 on 2017/4/22.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNewPageCollectionViewCell.h"

@interface AJNewPageCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;   /**< 图标图片视图*/
@property (nonatomic, strong) UILabel *iconNameLabel;       /**< 图标名字标签*/

@end

@implementation AJNewPageCollectionViewCell

#pragma mark - Overload Init
- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype) init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - InitView
- (void)initView{
    
    //原型数据
    CGFloat marginX     = 10.f;                     /**< 控件左右间距*/
    CGFloat marginY     = 10.f;                     /**< 控件上下间距*/
    CGFloat labelHeight = 14.f;                     /**< 标签高度*/
    CGFloat fontSize    = 14.f;                     /**< 标签字体大小*/
    UIColor *fontColor  = [UIColor darkGrayColor];  /**< 标签字体颜色*/
    
    self.iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(marginX, marginY, self.frame.size.width - 2 * marginX, self.frame.size.width - 2 *marginX);
        [self addSubview:imageView];
        imageView;
    });
    
    self.iconNameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, CGRectGetMaxY(self.iconImageView.frame) + marginY, self.frame.size.width, labelHeight);
        label.font = [UIFont systemFontOfSize:fontSize];
        label.textColor = fontColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        label;
    });
}


#pragma mark - AddRoundCorner
- (void)addRoundCorner:(UIImageView *)imageView{
//    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, NO, [UIScreen mainScreen].scale);
//    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:imageView.bounds.size.width * 0.5] addClip];
//    [imageView drawRect:imageView.bounds];
//    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    imageView.layer.cornerRadius = imageView.bounds.size.width * 0.5;
    imageView.layer.masksToBounds = YES;
}

#pragma mark - Setter
- (void) setImageName:(NSString *)imageName{
    _imageName = imageName;
    
    self.iconImageView.image = [UIImage imageNamed:imageName];
    [self addRoundCorner:self.iconImageView];
}

- (void)setLabelText:(NSString *)labelText{
    _labelText = labelText;
    
    self.iconNameLabel.text = labelText;
}

@end
