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
- (IBAction)ljpkAct:(UIButton *)sender;
@property(nonatomic,retain)PinKeModel * pinKeModel;
@property(nonatomic,assign)int smid;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
