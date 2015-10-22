//
//  CHShaiXuanViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/10/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
@protocol CHShaiXuanDelegate<NSObject>
- (void)addShaiXuan:(NSMutableArray *)arr;

@end
@interface CHShaiXuanViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)sureAct:(id)sender;
@property (nonatomic, weak) id <CHShaiXuanDelegate> delegate;

@end
