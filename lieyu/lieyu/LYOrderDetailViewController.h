//
//  LYOrderDetailViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "OrderInfoModel.h"
#import "NSObject+MJKeyValue.h"
@interface LYOrderDetailViewController : LYBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView;
    int sectionNum;
    UIView *dibuView;
    BOOL isFaqi;
    bool isfu;
    int userId;
    NSString *fukuanPKStr;
}
@property (nonatomic, assign)  BOOL isHaveBtn;
@property (nonatomic, retain)  OrderInfoModel *orderInfoModel;
@end
