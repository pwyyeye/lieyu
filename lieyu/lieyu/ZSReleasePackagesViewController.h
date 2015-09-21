//
//  ZSReleasePackagesViewController.h
//  lieyu
//
//  Created by SEM on 15/9/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface ZSReleasePackagesViewController : LYBaseViewController
{
    NSMutableArray *taocanDelList;
    NSString *fromTime;
    NSString *toTime;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
