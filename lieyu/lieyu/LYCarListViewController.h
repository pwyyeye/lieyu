//
//  LYCarListViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "chiheDetailCollectionCell.h"

@interface LYCarListViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) id<RefreshGoodsNum> numrefreshdelegate;

- (void)backToCHView;

@end
