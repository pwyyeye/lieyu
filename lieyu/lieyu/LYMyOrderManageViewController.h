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
@interface LYMyOrderManageViewController : LYBaseViewController<MenuHrizontalDelegate>
{
    MenuHrizontal *mMenuHriZontal;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@end
