//
//  LYPlayTogetherPayViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/17.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@interface LYPlayTogetherPayViewController : LYBaseViewController
- (IBAction)payAct:(UIButton *)sender;
@property(nonatomic,assign)int smid;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
