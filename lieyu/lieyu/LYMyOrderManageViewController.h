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

@end
