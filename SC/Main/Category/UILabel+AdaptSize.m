//
//  UILabel+AdaptSize.m
//  SC
//
//  Created by 潘安静 on 2017/6/3.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "UILabel+AdaptSize.h"

@implementation UILabel (AdaptSize)

- (void)adaptHeightWithText:(NSString *)textString WithFontSize:(CGFloat)fontSize WithWidth:(CGFloat)width{
    self.numberOfLines = 0;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName : paragraphStyle.copy};
    CGRect adaptRect = [textString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, adaptRect.size.height);
}

@end
