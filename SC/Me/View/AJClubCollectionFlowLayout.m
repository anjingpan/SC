//
//  AJClubCollectionFlowLayout.m
//  SC
//
//  Created by mac on 17/3/13.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJClubCollectionFlowLayout.h"

static CGFloat const kClubCollectionWidth = 120;  /**< 单个cell 的宽度*/
static CGFloat const kMaxScale = 0.3;             /**< 最大放大比例*/

@implementation AJClubCollectionFlowLayout

- (instancetype)init{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(kClubCollectionWidth, kClubCollectionWidth + 20); // 20为图片下文字的高度，保证图片为正方形
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.minimumLineSpacing = kClubCollectionWidth * kMaxScale;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    //消除控制台 warning
    //This is likely occurring because the flow layout "xyz" is modifying attributes returned by UICollectionViewFlowLayout without copying them
    NSArray * original   = [super layoutAttributesForElementsInRect:rect];
    NSArray * attributesArray = [[NSArray alloc] initWithArray:original copyItems:YES];
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    for (UICollectionViewLayoutAttributes *attribute in attributesArray) {
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            CGFloat distance = ABS(CGRectGetMidX(visibleRect) - attribute.center.x);
            if (distance < 50) {
                CGFloat scale = 1 + kMaxScale * (1- distance / kClubCollectionWidth);
                attribute.transform3D = CATransform3DMakeScale(scale, scale, 1);
            }
        }
    }
    
    return attributesArray;
}

@end
