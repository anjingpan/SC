//
//  AJTabBar.h
//  SC
//
//  Created by mac on 17/4/18.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickAddButton)(UIButton*);

@interface AJTabBar : UITabBar

@property (nonatomic, copy) clickAddButton clickAddButtonBlock;     /**< 新建按钮点击 Block*/
@end
