//
//  LPMyOrdersViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/4/7.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

#import "LPOrderDetailViewController.h"

@interface LPMyOrdersViewController : LYBaseViewController<LPOrderDetailDelegate,UITableViewDelegate,UITableViewDataSource>
{    
    UITableView *myTableView;
    UIScrollView *scrollView;
    NSMutableArray *arrayButton;
}
@property (nonatomic, assign) int orderIndex;
@property (nonatomic, strong) NSMutableArray *bagesArr;
@property (nonatomic, assign) BOOL isFreeOrdersList;

- (void)hideKongView;
- (void)addKongView;
@end
