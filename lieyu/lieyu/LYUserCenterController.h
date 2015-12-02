//
//  LYUserCenterController.h
//  lieyu
//
//  Created by pwy on 15/11/29.
//  Copyright © 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTTL.h"
@interface LYUserCenterController : UICollectionViewController<UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate >
@property(strong,nonatomic) NSArray *data;
@property(strong,nonatomic) OrderTTL *orderTTL;
@end
