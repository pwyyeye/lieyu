//
//  StrategyCommentListViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/9/3.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"

@protocol StrategyCommentSendDelegate <NSObject>

- (void)StrategySendCommentSuccess;
- (void)StrategyDeleteCommentSuccess;

@end

@interface StrategyCommentListViewController : LYBaseViewController

@property (nonatomic, strong) NSString *strategyId;

@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, assign) id<StrategyCommentSendDelegate> delegate;

@end
