//
//  LYShaiXuanViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/16.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
@protocol ShaiXuanDelegate<NSObject>
- (void)addCondition:(NSMutableArray *)arr;

@end
@interface LYShaiXuanViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)sureAct:(id)sender;
@property (nonatomic, weak) id <ShaiXuanDelegate> delegate;
@end
