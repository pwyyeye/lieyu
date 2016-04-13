//
//  LPMyOrdersViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/4/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

#import "LPOrderDetailViewController.h"

@interface LPMyOrdersViewController : LYBaseViewController<LPOrderDetailDelegate>
@property (nonatomic, assign) int orderIndex;
@end
