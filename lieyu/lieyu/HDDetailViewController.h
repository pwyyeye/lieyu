//
//  HDDetailViewController.h
//  lieyu
//
//  Created by 王婷婷 on 16/1/31.
//  Copyright © 2016年 狼族（上海）网络科技有限公司. All rights reserved.
//

#import "LYBaseViewController.h"
#import "YUOrderShareModel.h"
#import "JoinedTableViewCell.h"
@interface HDDetailViewController : LYBaseViewController<HDDetailJumpToFriendDetail>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UILabel *label_bottom;
- (IBAction)WannaJoin:(UIButton *)sender;

@property (nonatomic, strong) YUOrderShareModel *YUModel;
@property (nonatomic, strong) NSString *YUid;
@end
