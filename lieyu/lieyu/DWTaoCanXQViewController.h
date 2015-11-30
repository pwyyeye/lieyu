//
//  DWTaoCanXQViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface DWTaoCanXQViewController : LYBaseViewController
- (IBAction)queryAct:(UIButton *)sender;
- (IBAction)warnAct:(UIButton *)sender;
- (IBAction)payAct:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int smid;
@property (copy, nonatomic) NSString *dateStr;
@property (nonatomic,copy) NSString *weekStr;
@end
