//
//  ZSSeatControlViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/14.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface ZSSeatControlViewController : LYBaseViewController{
    NSMutableArray *listArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
