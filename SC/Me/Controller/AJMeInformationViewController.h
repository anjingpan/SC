//
//  AJMeInformationViewController.h
//  SC
//
//  Created by mac on 17/3/9.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJBaseViewController.h"

@interface AJMeInformationViewController : AJBaseViewController

@property (nonatomic, assign) BOOL isAllowEdit;     /**< 视图是否可编辑*/
@property (nonatomic, strong) NSString *userId;     /**< 用户编号*/

@end
