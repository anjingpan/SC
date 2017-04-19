//
//  AJTabBar.m
//  SC
//
//  Created by mac on 17/4/18.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJTabBar.h"

static CGFloat kTabBarButtonCount = 5.f;        /**< tabBar按钮总数*/
static CGFloat ktabBarAddButtonIndex = 2.f;     /**< 新建按钮的位置*/

@interface AJTabBar ()

@property (nonatomic, strong) UIButton *addButton;  /**< 新建按钮*/
@end

@implementation AJTabBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.addButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor orangeColor];
            [button setImage:[UIImage imageNamed:@"TabBar_Add"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addNewPage:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            button;
        });

    }
    return self;
}

- (void)addNewPage:(UIButton *)button{
    if (self.clickAddButtonBlock) {
        self.clickAddButtonBlock(button);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat tabBarButtonWidth = self.frame.size.width / kTabBarButtonCount;
    CGFloat tabBarButtonIndex = 0;
    Class tabBarButtonClass = NSClassFromString(@"UITabBarButton");
    
    //原型数据
    CGFloat marginY = 5.f;
    CGFloat marginX = 10.f;
    //新建按钮居中
    self.addButton.frame = CGRectMake((self.frame.size.width - tabBarButtonWidth) * 0.5 + marginX, marginY, tabBarButtonWidth - 2 * marginX, self.frame.size.height - 2 * marginY);
    self.addButton.layer.cornerRadius = 5.f;
    
    for (UIView *barButton in self.subviews) {
        if ([barButton isKindOfClass:tabBarButtonClass]) {
            CGRect originRect = barButton.frame;
            originRect.size.width = tabBarButtonWidth;
            originRect.origin.x = tabBarButtonWidth * tabBarButtonIndex;
            barButton.frame = originRect;
            
            tabBarButtonIndex ++;
            //当到达新建按钮所在的位置时，直接设置下一个按钮
            if (tabBarButtonIndex == ktabBarAddButtonIndex) {
                tabBarButtonIndex ++;
            }
        }
    }
    
}

@end
