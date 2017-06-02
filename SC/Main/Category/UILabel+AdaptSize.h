//
//  UILabel+AdaptSize.h
//  SC
//
//  Created by 潘安静 on 2017/6/3.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (AdaptSize)

//自适应高度，通过文本，字号以及限定的宽度
- (void)adaptHeightWithText:(NSString *)textString WithFontSize:(CGFloat)fontSize WithWidth:(CGFloat)width;

@end
