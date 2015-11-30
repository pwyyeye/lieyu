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
@interface LYwoYaoDinWeiMainViewController : LYBaseViewController<NeedHideNavigationBar,MenuHrizontalDelegate>
{
    MenuHrizontal *mMenuHriZontal;
    NSMutableArray *weekDateArr;
    NSString *datePar;
}
- (IBAction)soucangAct:(UIButton *)sender;
- (IBAction)backAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (assign, nonatomic) int barid;

@end
