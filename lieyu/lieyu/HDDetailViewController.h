//
//  HDDetailViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "YUOrderShareModel.h"
@interface HDDetailViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
- (IBAction)WannaJoin:(UIButton *)sender;

@property (nonatomic, strong) YUOrderShareModel *YUModel;
@end
