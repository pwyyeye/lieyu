//
//  CHDoOrderViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/24.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface CHDoOrderViewController : LYBaseViewController
@property (copy, nonatomic) NSString *ids;
- (IBAction)payAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
