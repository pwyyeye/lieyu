//
//  ZSMaintViewController.h
//  lieyu
//
//  Created by SEM on 15/9/14.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "NeedHideNavigationBar.h"
@interface ZSMaintViewController : LYBaseViewController<NeedHideNavigationBar>
{
    NSMutableArray *listArr;
    UILabel *namelal;
    UILabel *orderInfoLal;
    UIImageView *cImageView;
    UIImageView *myPhotoImageView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIButton *btnBack;

@end
