//
//  AJNewPageViewController.h
//  SC
//
//  Created by 潘安静 on 2017/4/22.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AJNewPageViewControllerDelegate <NSObject>

/**
 点击 collectionView 对应的 cell

 @param section 是第几个 Cell ，来辨别 cell
 */
- (void)selectCollectionViewCellWithSection:(NSInteger)section;

@end
@interface AJNewPageViewController : UIViewController

@property(nonatomic, weak) id<AJNewPageViewControllerDelegate> delegate;    /**< 代理*/
@end
