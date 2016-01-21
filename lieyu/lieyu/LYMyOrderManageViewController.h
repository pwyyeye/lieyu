//
//  LYMyOrderManageViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/23.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "MenuHrizontal.h"
#import "NeedHideNavigationBar.h"
#import "NSObject+MJKeyValue.h"
#import "MJRefresh.h"

typedef NS_ENUM(NSInteger, LYOrderType) {
    LYOrderTypeDefault=0,//all
    LYOrderTypeWaitPay=1,//待付款
    LYOrderTypeWaitConsumption=2,//待消费
    LYOrderTypeWaitRebate=4,//待评价
    LYOrderTypeWaitEvaluation=3,//待返利
    LYOrderTypeWaitPayBack=5//待退款
    
};

@interface LYMyOrderManageViewController : LYBaseViewController<MenuHrizontalDelegate>
{
    MenuHrizontal *mMenuHriZontal;
    NSMutableArray *dataList;
    int userId;
    int pageCount;
    int perCount;
    NSMutableDictionary *nowDic;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *tobView;
@property (weak, nonatomic) IBOutlet UIView *nodataView;
@property (weak, nonatomic) IBOutlet UIImageView *kongImageView;

@property(assign,nonatomic) LYOrderType orderType;



- (IBAction)gohomeAct:(UIButton *)sender;

@end
