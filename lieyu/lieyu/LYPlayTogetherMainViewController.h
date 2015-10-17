//
//  LYPlayTogetherMainViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/16.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "PinKeModel.h"
@interface LYPlayTogetherMainViewController : LYBaseViewController
@property(nonatomic,retain)PinKeModel * pinKeModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
