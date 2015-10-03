//
//  BiaoQianChooseViewController.h
//  lieyu
//
//  Created by 薛斯岐 on 15/9/22.
//  Copyright (c) 2015年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
@protocol BiaoQianChooseDelegate<NSObject>
- (void)addBiaoQian:(NSMutableArray *)arr;

@end
@interface BiaoQianChooseViewController : LYBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)sureAct:(id)sender;
@property (nonatomic, weak) id <BiaoQianChooseDelegate> delegate;
@end
