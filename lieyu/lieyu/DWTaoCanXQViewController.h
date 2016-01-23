//
//  DWTaoCanXQViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/21.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@class JiuBaModel;

@interface DWTaoCanXQViewController : LYBaseViewController
- (IBAction)queryAct:(UIButton *)sender;
- (IBAction)warnAct:(UIButton *)sender;
- (IBAction)payAct:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *image_header;
@property (weak, nonatomic) IBOutlet UIButton *btn_back;
@property (weak, nonatomic) IBOutlet UIButton *btn_collect;
@property (weak, nonatomic) IBOutlet UIButton *btn_share;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) int smid;
@property (copy, nonatomic) NSString *dateStr;
@property (nonatomic,copy) NSString *weekStr;
@property (nonatomic,strong) JiuBaModel *jiubaModel;
@end
