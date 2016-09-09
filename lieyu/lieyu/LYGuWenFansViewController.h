//
//  LYGuWenFansViewController.h
//  lieyu
//
//  Created by 狼族 on 16/6/1.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface LYGuWenFansViewController : LYBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *kongLabel;

@property (nonatomic, assign) int type;//0表示粉丝，1表示关注
@property (nonatomic, strong) NSString *userID;//普通用户或者专属经理的ID

@end
