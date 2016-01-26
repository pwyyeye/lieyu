//
//  LYwoYaoDinWeiMainViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/20.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "NeedHideNavigationBar.h"
#import "MenuHrizontal.h"
#import "ManagersView.h"
@interface LYwoYaoDinWeiMainViewController : LYBaseViewController<MenuHrizontalDelegate,ChooseManage>
{
    MenuHrizontal *mMenuHriZontal;
    NSMutableArray *weekDateArr;
    NSString *datePar;
    UITableView *menuTableView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *managersView;
@property (assign, nonatomic) int barid;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *NumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end
