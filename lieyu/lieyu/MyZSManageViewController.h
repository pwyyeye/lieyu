//
//  MyZSManageViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/25.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "LYZSeditView.h"
@interface MyZSManageViewController : LYBaseViewController{
    NSMutableArray *zsList;
    UIView  *_bgView;
    LYZSeditView *seditView;
    UIBarButtonItem *rightBtn;
    UserModel *userModel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
